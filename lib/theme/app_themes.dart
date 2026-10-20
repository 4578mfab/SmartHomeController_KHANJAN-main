import 'package:flutter/material.dart';

class AppThemeData {
  final String name;
  final String subtitle;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color card;
  final Color text;
  final Color accent;

  const AppThemeData({
    required this.name,
    required this.subtitle,
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
    // 0 - Fresh Mint
    AppThemeData(
      name: 'Fresh Mint',
      subtitle: 'خنک • آرام • متعادل',
      primary: Color(0xFF4CAF7A),
      secondary: Color(0xFFF4D35E),
      background: Color(0xFFF8FBF6),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF2D3436),
      accent: Color(0xFFE8F5E9),
    ),
    // 1 - Soft Sky
    AppThemeData(
      name: 'Soft Sky',
      subtitle: 'هوا • سبک • تازه',
      primary: Color(0xFF4A90D9),
      secondary: Color(0xFFFF8A65),
      background: Color(0xFFF5F9FC),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF2C3E50),
      accent: Color(0xFFE3F2FD),
    ),
    // 2 - Warm Peach
    AppThemeData(
      name: 'Warm Peach',
      subtitle: 'گرم • نرم • دوستانه',
      primary: Color(0xFF7B1FA2),
      secondary: Color(0xFFC2185B),
      background: Color(0xFFFFF8F5),
      card: Color(0xFFFFFFFF),
      text: Color(0xFF4E342E),
      accent: Color(0xFFFFF3E0),
    ),
  ];

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
