import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF635BFF);
  static const secondary = Color(0xFF8B7CFF);
  static const background = Color(0xFFF6F7FB);
  static const surface = Colors.white;
  static const text = Color(0xFF161A2D);
  static const muted = Color(0xFF7B8195);
  static const success = Color(0xFF16A085);
  static const danger = Color(0xFFE85D75);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Arial',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    );
  }
}
