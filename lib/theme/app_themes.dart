import 'package:flutter/material.dart';

class AppThemeData {
  final String name;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color card;
  final Color text;
  final Color accent;

  const AppThemeData({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.card,
    required this.text,
    required this.accent,
  });
}

class AppThemes {
  static const List<AppThemeData> themes = [
    AppThemeData(
      name: 'mint',
      primary: Color(0xFF43A047),
      secondary: Color(0xFF81C784),
      background: Color(0xFFF3FBF4),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF1B5E20),
      accent: Color(0xFFE8F5E9),
    ),
    AppThemeData(
      name: 'sky',
      primary: Color(0xFF1E88E5),
      secondary: Color(0xFF64B5F6),
      background: Color(0xFFF3F8FD),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF0D47A1),
      accent: Color(0xFFE3F2FD),
    ),
    AppThemeData(
      name: 'coral',
      primary: Color(0xFFFF7043),
      secondary: Color(0xFFFFAB91),
      background: Color(0xFFFFF6F3),
      card: Color(0xFFFFFFFF),
      text: Color(0xFFBF360C),
      accent: Color(0xFFFBE9E7),
    ),
    AppThemeData(
      name: 'purple',
      primary: Color(0xFF8E24AA),
      secondary: Color(0xFFBA68C8),
      background: Color(0xFFFBF5FC),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF4A148C),
      accent: Color(0xFFF3E5F5),
    ),
    AppThemeData(
      name: 'teal',
      primary: Color(0xFF00897B),
      secondary: Color(0xFF4DB6AC),
      background: Color(0xFFF1FAF9),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF004D40),
      accent: Color(0xFFE0F2F1),
    ),
    AppThemeData(
      name: 'amber',
      primary: Color(0xFFFFA000),
      secondary: Color(0xFFFFD54F),
      background: Color(0xFFFFFBF0),
      card: Color(0xFFFFFFFF),
      text: Color(0xFFE65100),
      accent: Color(0xFFFFF8E1),
    ),
    AppThemeData(
      name: 'rose',
      primary: Color(0xFFE91E63),
      secondary: Color(0xFFF48FB1),
      background: Color(0xFFFFF5F8),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF880E4F),
      accent: Color(0xFFFCE4EC),
    ),
    AppThemeData(
      name: 'indigo',
      primary: Color(0xFF3949AB),
      secondary: Color(0xFF7986CB),
      background: Color(0xFFF5F6FC),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF1A237E),
      accent: Color(0xFFE8EAF6),
    ),
    AppThemeData(
      name: 'lime',
      primary: Color(0xFF7CB342),
      secondary: Color(0xFFAED581),
      background: Color(0xFFF7FBF1),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF33691E),
      accent: Color(0xFFF1F8E9),
    ),
    AppThemeData(
      name: 'cyan',
      primary: Color(0xFF00ACC1),
      secondary: Color(0xFF4DD0E1),
      background: Color(0xFFF0FBFC),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF006064),
      accent: Color(0xFFE0F7FA),
    ),
  ];

  static int clampIndex(int index) {
    if (themes.isEmpty) return 0;
    return index.clamp(0, themes.length - 1);
  }

  static AppThemeData of(int index) => themes[clampIndex(index)];

  static ThemeData buildTheme(AppThemeData t) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: t.primary,
      scaffoldBackgroundColor: t.background,
      colorScheme: ColorScheme.light(
        primary: t.primary,
        secondary: t.secondary,
        surface: t.card,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: t.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.card,
        foregroundColor: t.text,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: t.text,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: t.card,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return t.primary;
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return t.primary.withOpacity(0.4);
          }
          return Colors.grey.shade300;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.accent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
