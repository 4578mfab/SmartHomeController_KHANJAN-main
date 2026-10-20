import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/relay_config.dart';
import '../services/mqtt_service.dart';
import '../services/settings_service.dart';
import '../theme/app_themes.dart';
import '../widgets/temperature_card.dart';
import '../widgets/relay_switch.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _settingsService = SettingsService();
  final _mqtt = MqttService();

  AppSettings _settings = AppSettings();
  String _temperature = '';
  bool _connected = false;
  bool _espOnline = false;
  bool _loading = true;
  String? _error;

  StreamSubscription? _connSub;
  StreamSubscription? _tempSub;
  StreamSubscription? _relaySub;
  StreamSubscription? _espSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final s = await _settingsService.load();
    setState(() {
      _settings = s;
      _loading = false;
    });
    _listenMqtt();
    await _connectMqtt();
  }

  void _listenMqtt() {
    _connSub = _mqtt.connectionStream.listen((c) {
      if (mounted) setState(() => _connected = c);
    });
    _tempSub = _mqtt.temperatureStream.listen((t) {
      if (mounted) setState(() => _temperature = t);
    });
    _relaySub = _mqtt.relayStateStream.listen((map) {
      if (!mounted) return;
      setState(() {
        for (final entry in map.entries) {
          final idx = _settings.relays.indexWhere((r) => r.id == entry.key);
          if (idx >= 0) {
            _settings.relays[idx] =
                _settings.relays[idx].copyWith(isOn: entry.value);
          }
        }
      });
    });
    _espSub = _mqtt.espStatusStream.listen((online) {
      if (mounted) setState(() => _espOnline = online);
    });
  }

  Future<void> _connectMqtt() async {
    setState(() {
      _error = null;
      _espOnline = false;
    });
    try {
      await _mqtt.connect(_settings);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'اتصال برقرار نشد. تنظیمات را بررسی کنید.');
      }
    }
  }

  Future<void> _onToggle(RelayConfig relay, bool value) async {
    setState(() {
      final idx = _settings.relays.indexWhere((r) => r.id == relay.id);
      if (idx >= 0) {
        _settings.relays[idx] = relay.copyWith(isOn: value);
      }
    });
    await _mqtt.toggleRelay(relay, value);
  }

  Future<void> _openSettings() async {
    final result = await Navigator.push<AppSettings>(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(initialSettings: _settings),
      ),
    );
    if (result != null && mounted) {
      setState(() => _settings = result);
      await _settingsService.save(result);
      await _connectMqtt();
    }
  }

  @override
  void dispose() {
    _connSub?.cancel();
    _tempSub?.cancel();
    _relaySub?.cancel();
    _espSub?.cancel();
    _mqtt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.themes[_settings.themeIndex.clamp(0, 2)];
    final materialTheme = AppThemes.buildTheme(theme);

    if (_loading) {
      return Scaffold(
        backgroundColor: theme.background,
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }

    return Theme(
      data: materialTheme,
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: AppBar(
          title: const Text('KHANJAN IoT Home'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                _connected ? Icons.cloud_done : Icons.cloud_off,
                color: _connected ? theme.primary : Colors.redAccent,
                size: 22,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: _openSettings,
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _connectMqtt,
          color: theme.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ESP32 Online / Offline status card
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _espOnline
                      ? Colors.green.withOpacity(0.12)
                      : Colors.red.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _espOnline ? Colors.green : Colors.redAccent,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _espOnline ? Icons.memory : Icons.memory_outlined,
                      color: _espOnline ? Colors.green : Colors.redAccent,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وضعیت ESP32',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.text.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            _espOnline ? 'آنلاین' : 'آفلاین',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _espOnline
                                  ? Colors.green.shade700
                                  : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _espOnline ? Colors.green : Colors.redAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_espOnline ? Colors.green : Colors.red)
                                .withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              TemperatureCard(temperature: _temperature, theme: theme),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'کلیدهای کنترل',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.text,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_settings.relays.length} دستگاه',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.text.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._settings.relays.map(
                (r) => RelaySwitchTile(
                  relay: r,
                  theme: theme,
                  enabled: _connected,
                  onChanged: (v) => _onToggle(r, v),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'تم رنگی',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.text,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: List.generate(AppThemes.themes.length, (i) {
                  final t = AppThemes.themes[i];
                  final selected = i == _settings.themeIndex;
                  return ChoiceChip(
                    label: Text(t.name),
                    selected: selected,
                    selectedColor: t.primary.withOpacity(0.2),
                    onSelected: (_) async {
                      setState(() => _settings.themeIndex = i);
                      await _settingsService.save(_settings);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
