import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/app_settings.dart';
import '../models/relay_config.dart';

class MqttService {
  MqttServerClient? _client;
  AppSettings? _settings;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSubscription;

  final _connectionController = StreamController<bool>.broadcast();
  final _temperatureController = StreamController<String>.broadcast();
  final _relayStateController = StreamController<Map<String, bool>>.broadcast();
  final _espStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get temperatureStream => _temperatureController.stream;
  Stream<Map<String, bool>> get relayStateStream => _relayStateController.stream;
  Stream<bool> get espStatusStream => _espStatusController.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect(AppSettings settings) async {
    await disconnect();
    _settings = settings;

    // Public MQTT brokers require client IDs to be unique across all users.
    // Keep the configured value as a readable prefix, but add a short unique
    // suffix so another installation using the same default cannot kick us off.
    final configuredId = settings.clientId.trim().isEmpty
        ? 'khanjan'
        : settings.clientId.trim().replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final maxPrefixLength = 22 - uniqueSuffix.length;
    final prefix = configuredId.length > maxPrefixLength
        ? configuredId.substring(0, maxPrefixLength)
        : configuredId;
    final clientId = '${prefix}_$uniqueSuffix';

    final broker = settings.broker.trim();
    final port = settings.port == 0 ? 1883 : settings.port;

    // Respect the user's explicit connection-method setting. A port number
    // alone must not silently switch a TCP connection to WebSocket.

    _client = MqttServerClient.withPort(broker, clientId, port);
    _client!.logging(on: true);
    // Explicitly use MQTT 3.1.1 rather than relying on the package default.
    _client!.setProtocolV311();
    // Allow enough time for the broker's CONNACK on slower mobile networks.
    _client!.connectTimeoutPeriod = 10000;
    _client!.keepAlivePeriod = 60;
    _client!.autoReconnect = true;
    // Re-subscribe in onAutoReconnected below so the behaviour is explicit
    // and does not depend on the client's automatic subscription cache.
    _client!.resubscribeOnAutoReconnect = false;
    _client!.secure = false;

    if (settings.useWebSocket) {
      _client!.useWebSocket = true;
      _client!.websocketProtocols = ['mqtt'];
    }

    _client!.onConnected = () {
      _connectionController.add(true);
      _subscribeAll();
    };

    _client!.onDisconnected = () {
      _connectionController.add(false);
      _espStatusController.add(false);
    };

    _client!.onAutoReconnected = () {
      _connectionController.add(true);
      _subscribeAll();
    };

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean();

    if (settings.username.trim().isNotEmpty) {
      connMess.authenticateAs(
        settings.username.trim(),
        settings.password,
      );
    }
    _client!.connectionMessage = connMess;

    // Start listening BEFORE connect/subscribe so retained messages (for
    // example ESP32 online and relay states) are not missed on first connect.
    _updatesSubscription = _client!.updates?.listen(_onMessage);

    try {
      await _client!.connect();
    } catch (e) {
      final status = _client?.connectionStatus;
      final detailedError = '$e | MQTT state: ${status?.state}, broker return code: ${status?.returnCode}';
      _connectionController.add(false);
      _espStatusController.add(false);
      await _updatesSubscription?.cancel();
      _updatesSubscription = null;
      try {
        _client?.disconnect();
      } catch (_) {}
      _client = null;
      throw Exception(detailedError);
    }

    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      _connectionController.add(true);
      // onConnected performs the initial subscription. Do not subscribe a
      // second time here.
    } else {
      final status = _client?.connectionStatus;
      _connectionController.add(false);
      _espStatusController.add(false);
      await _updatesSubscription?.cancel();
      _updatesSubscription = null;
      try {
        _client?.disconnect();
      } catch (_) {}
      _client = null;
      throw Exception('MQTT connection failed | state: ${status?.state}, broker return code: ${status?.returnCode}');
    }
  }

  void _subscribeAll() {
    if (_client == null || _settings == null) return;
    final s = _settings!;

    if (s.temperatureTopic.trim().isNotEmpty) {
      _client!.subscribe(s.temperatureTopic.trim(), MqttQos.atLeastOnce);
    }
    if (s.espStatusTopic.trim().isNotEmpty) {
      _client!.subscribe(s.espStatusTopic.trim(), MqttQos.atLeastOnce);
    }
    for (final r in s.relays) {
      if (r.stateTopic.trim().isNotEmpty) {
        _client!.subscribe(r.stateTopic.trim(), MqttQos.atLeastOnce);
      }
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    for (final event in events) {
      final topic = event.topic;
      final recMess = event.payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message)
              .trim();

      if (_settings == null) continue;

      if (topic == _settings!.espStatusTopic) {
        // SmartControl V1.09 publishes a retained multi-line status such as:
        // "ESP32 : Online\nLED : ON\nRelay : OFF"
        // The last-will message is "ESP32 Offline".
        final normalized = payload.toLowerCase();
        final online = normalized == 'online' ||
            normalized == 'on' ||
            normalized == '1' ||
            normalized == 'true' ||
            (normalized.contains('esp32') &&
                normalized.contains('online') &&
                !normalized.contains('offline'));
        _espStatusController.add(online);
        continue;
      }

      if (topic == _settings!.temperatureTopic) {
        _temperatureController.add(payload);
        continue;
      }

      for (final r in _settings!.relays) {
        if (topic == r.stateTopic) {
          final on = payload.toUpperCase() == r.onPayload.toUpperCase() ||
              payload == '1' ||
              payload.toLowerCase() == 'true';
          _relayStateController.add({r.id: on});
          break;
        }
      }
    }
  }

  Future<void> publish(String topic, String message) async {
    if (_client == null || !isConnected) return;
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  Future<void> toggleRelay(RelayConfig relay, bool turnOn) async {
    final payload = turnOn ? relay.onPayload : relay.offPayload;
    await publish(relay.commandTopic, payload);
  }

  Future<void> disconnect() async {
    await _updatesSubscription?.cancel();
    _updatesSubscription = null;
    try {
      _client?.disconnect();
    } catch (_) {}
    _client = null;
    _connectionController.add(false);
    _espStatusController.add(false);
  }

  void dispose() {
    disconnect();
    _connectionController.close();
    _temperatureController.close();
    _relayStateController.close();
    _espStatusController.close();
  }
}
