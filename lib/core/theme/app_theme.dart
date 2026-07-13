import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFDC0A2D);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color surfaceColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: surfaceColor,
      ),

      scaffoldBackgroundColor: primaryColor,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 7,
      ),
    );
  }
}
