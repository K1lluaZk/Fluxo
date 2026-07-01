import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 255, 255, 255),
      surface: Color(0xFF0F172A),
    ),
    scaffoldBackgroundColor: const Color(0xFF020617),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 255, 254, 255),
      foregroundColor: Colors.white,
    ),
  );
}