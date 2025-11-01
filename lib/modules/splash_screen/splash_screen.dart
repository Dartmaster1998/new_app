import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go("/home");
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 💥 предотвращает утечку/ошибку в тестах
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo.png"),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
