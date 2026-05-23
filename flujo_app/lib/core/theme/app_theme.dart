import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark(
    useMaterial3: true,
  ).copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7C3AED),
      surface: Color(0xFF0F172A),
    ),
    scaffoldBackgroundColor: const Color(0xFF020617),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF7C3AED),
      foregroundColor: Colors.white,
    ),
  );
}