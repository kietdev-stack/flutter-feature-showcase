import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _ink = Color(0xFF171A1F);
  static const _paper = Color(0xFFF7F5F0);
  static const _accent = Color(0xFF2D6A5F);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: Brightness.light,
      surface: _paper,
    );
    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: _paper,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _ink,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Color(0xFFE2DED4)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }
}
