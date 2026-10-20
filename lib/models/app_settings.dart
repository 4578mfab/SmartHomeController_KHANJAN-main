import 'relay_config.dart';

class AppSettings {
  String broker;
  int port;
  String clientId;
  String username;
  String password;
  String temperatureTopic;
  String espStatusTopic;
  bool useWebSocket;
  int themeIndex;
  List<RelayConfig> relays;

  AppSettings({
    this.broker = 'broker.hivemq.com',
    this.port = 1883,
    this.clientId = 'khanjan_iot_app',
    this.username = '',
    this.password = '',
    this.temperatureTopic = 'home/temperature',
    this.espStatusTopic = 'home/esp32/status',
    this.useWebSocket = false,
    this.themeIndex = 0,
    List<RelayConfig>? relays,
  }) : relays = relays ?? _defaultRelays();

  static List<RelayConfig> _defaultRelays() {
    return List.generate(5, (i) {
      final n = i + 1;
      return RelayConfig(
        id: 'relay_$n',
        name: 'کلید $n',
        commandTopic: 'home/relay$n/set',
        stateTopic: 'home/relay$n/state',
      );
    });
  }

  Map<String, dynamic> toJson() => {
        'broker': broker,
        'port': port,
        'clientId': clientId,
        'username': username,
        'password': password,
        'temperatureTopic': temperatureTopic,
        'espStatusTopic': espStatusTopic,
        'useWebSocket': useWebSocket,
        'themeIndex': themeIndex,
        'relays': relays.map((r) => r.toJson()).toList(),
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final list = (json['relays'] as List<dynamic>?)
            ?.map((e) => RelayConfig.fromJson(e as Map<String, dynamic>))
            .toList() ??
        AppSettings._defaultRelays();
    return AppSettings(
      broker: json['broker'] as String? ?? 'broker.hivemq.com',
      port: json['port'] as int? ?? 1883,
      clientId: json['clientId'] as String? ?? 'khanjan_iot_app',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      temperatureTopic: json['temperatureTopic'] as String? ?? 'home/temperature',
      espStatusTopic: json['espStatusTopic'] as String? ?? 'home/esp32/status',
      useWebSocket: json['useWebSocket'] as bool? ?? false,
      themeIndex: json['themeIndex'] as int? ?? 0,
      relays: list,
    );
  }
}
