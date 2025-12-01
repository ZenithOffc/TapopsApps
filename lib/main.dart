import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAPOPS ARMAMENTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6A0DAD),
        scaffoldBackgroundColor: const Color(0xFF0A0015),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6A0DAD),
          secondary: Color(0xFFFF0040),
          surface: Color(0xFF1A0025),
          background: Color(0xFF0A0015),
        ),
        fontFamily: 'Rajdhani',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFFFF0040),
            letterSpacing: 1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF888888),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
