import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/relay_config.dart';

class SettingsService {
  static const _key = 'khanjan_app_settings';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return AppSettings();
    try {
      final settings = AppSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      // Migrate the previous app's stock broker choice. Do not touch custom
      // broker configurations or any relay/topic settings.
      if (settings.broker.trim() == 'test.mosquitto.org') {
        settings.broker = 'broker.hivemq.com';
        settings.port = 1883;
        settings.useWebSocket = false;
        await save(settings);
      }
      return settings;
    } catch (_) {
      return AppSettings();
    }
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }

  Future<void> updateRelays(List<RelayConfig> relays) async {
    final s = await load();
    s.relays = relays;
    await save(s);
  }
}
