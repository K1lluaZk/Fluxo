import 'package:flutter/material.dart';

class AppTheme {
  // ==========================
  // TEMA CLARO
  // ==========================
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
  ).copyWith(
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFFFFFF),      // Tarjetas
      onPrimary: Color(0xFF111827),

      secondary: Color(0xFF10B981),    // Verde elegante
      onSecondary: Colors.white,

      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF111827),

      error: Color(0xFFDC2626),
    ),

    scaffoldBackgroundColor: const Color(0xFFF5F7F6),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF5F7F6),
      foregroundColor: Color(0xFF111827),
      elevation: 0,
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF10B981),
      foregroundColor: Colors.white,
    ),

    dividerColor: Colors.grey,

    hintColor: const Color(0xFF6B7280),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  // ==========================
  // TEMA OSCURO
  // ==========================
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
  ).copyWith(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF161B22),      // Tarjetas
      onPrimary: Colors.white,

      secondary: Color(0xFF3B82F6),    // Azul elegante
      onSecondary: Colors.white,

      surface: Color(0xFF0B0F14),
      onSurface: Colors.white,

      error: Color(0xFFEF4444),
    ),

    scaffoldBackgroundColor: const Color(0xFF09090B),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF09090B),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3B82F6),
      foregroundColor: Colors.white,
    ),

    dividerColor: Colors.white24,

    hintColor: const Color(0xFF94A3B8),

    cardTheme: CardThemeData(
      color: const Color(0xFF161B22),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}