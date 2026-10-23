import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final AppThemeData theme;

  const SplashScreen({super.key, required this.theme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return Scaffold(
      backgroundColor: t.background,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Smart Home Logo
              Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [t.primary.withOpacity(0.20), t.secondary.withOpacity(0.12)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: t.primary.withOpacity(0.22), width: 1.5),
                  boxShadow: [BoxShadow(color: t.primary.withOpacity(0.12), blurRadius: 22, offset: const Offset(0, 8))],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.home_rounded, size: 76, color: t.primary),
                    Positioned(
                      right: 24,
                      bottom: 25,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(color: t.secondary, shape: BoxShape.circle, border: Border.all(color: t.background, width: 3)),
                        child: Icon(Icons.wifi_rounded, size: 14, color: t.background),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'KHANJAN',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: t.text,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'IOT HOME',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: t.text.withOpacity(0.55),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(t.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final AppThemeData theme;

  const SplashScreen({super.key, required this.theme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return Scaffold(
      backgroundColor: t.background,
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Smart Home Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: t.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home_rounded,
                  size: 72,
                  color: t.primary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'KHANJAN',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: t.text,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'IOT HOME',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: t.text.withOpacity(0.55),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(t.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
