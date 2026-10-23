import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/app_settings.dart';
import 'services/settings_service.dart';
import 'theme/app_themes.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const KhanjanApp());
}

class KhanjanApp extends StatefulWidget {
  const KhanjanApp({super.key});

  @override
  State<KhanjanApp> createState() => _KhanjanAppState();
}

class _KhanjanAppState extends State<KhanjanApp> {
  AppSettings _settings = AppSettings();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await SettingsService().load();
    setState(() {
      _settings = s;
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final themeData = AppThemes.themes[_settings.themeIndex.clamp(0, AppThemes.themes.length - 1)];
    final materialTheme = AppThemes.buildTheme(themeData);

    return MaterialApp(
      title: 'KHANJAN IoT Home',
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      home: SplashScreen(theme: themeData),
    );
  }
}
