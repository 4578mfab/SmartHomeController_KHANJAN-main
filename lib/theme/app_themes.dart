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
    // Calm green
    AppThemeData(name: 'Mint', subtitle: 'سبز آرام', primary: Color(0xFF168B70), secondary: Color(0xFFFFB547), background: Color(0xFFF2F7F5), card: Color(0xFFFFFFFF), text: Color(0xFF18332E), accent: Color(0xFFE2F2EC)),
    // Clear blue
    AppThemeData(name: 'Ocean', subtitle: 'آبی اقیانوسی', primary: Color(0xFF2676D2), secondary: Color(0xFFFF8A65), background: Color(0xFFF1F6FC), card: Color(0xFFFFFFFF), text: Color(0xFF1B2D42), accent: Color(0xFFE1EDFA)),
    // Violet
    AppThemeData(name: 'Violet', subtitle: 'بنفش مدرن', primary: Color(0xFF7654C8), secondary: Color(0xFFED6A9B), background: Color(0xFFF6F3FC), card: Color(0xFFFFFFFF), text: Color(0xFF302545), accent: Color(0xFFEDE6FA)),
    // Warm amber
    AppThemeData(name: 'Amber', subtitle: 'کهربایی گرم', primary: Color(0xFFB96B16), secondary: Color(0xFF168B70), background: Color(0xFFFFF8EE), card: Color(0xFFFFFFFF), text: Color(0xFF3D2B1A), accent: Color(0xFFFFEED5)),
    // Graphite dark
    AppThemeData(name: 'Night', subtitle: 'تیره و آرام', primary: Color(0xFF55D6BE), secondary: Color(0xFFFFC857), background: Color(0xFF101923), card: Color(0xFF1B2835), text: Color(0xFFEAF2F8), accent: Color(0xFF263746)),
    // Rose
    AppThemeData(name: 'Rose', subtitle: 'رز ملایم', primary: Color(0xFFC34D79), secondary: Color(0xFF3878B8), background: Color(0xFFFFF4F7), card: Color(0xFFFFFFFF), text: Color(0xFF402531), accent: Color(0xFFFBE3EC)),
    // Teal
    AppThemeData(name: 'Teal', subtitle: 'فیروزه‌ای', primary: Color(0xFF087E8B), secondary: Color(0xFFF4A261), background: Color(0xFFF0F8F8), card: Color(0xFFFFFFFF), text: Color(0xFF17363A), accent: Color(0xFFDDF1F1)),
    // Slate
    AppThemeData(name: 'Slate', subtitle: 'خاکستری آبی', primary: Color(0xFF526A82), secondary: Color(0xFFE0A458), background: Color(0xFFF2F5F8), card: Color(0xFFFFFFFF), text: Color(0xFF253545), accent: Color(0xFFE4EBF1)),
  ];

  static ThemeData buildTheme(AppThemeData t) {
    return ThemeData(
      useMaterial3: true,
      brightness: t.background.computeLuminance() < 0.15 ? Brightness.dark : Brightness.light,
      primaryColor: t.primary,
      scaffoldBackgroundColor: t.background,
      colorScheme: ColorScheme(
        brightness: t.background.computeLuminance() < 0.15 ? Brightness.dark : Brightness.light,
        primary: t.primary, onPrimary: t.background.computeLuminance() < 0.15 ? const Color(0xFF10231F) : Colors.white,
        secondary: t.secondary, onSecondary: Colors.white,
        error: Colors.redAccent, onError: Colors.white,
        surface: t.card, onSurface: t.text,
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
