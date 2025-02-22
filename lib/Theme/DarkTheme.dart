import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  primaryColor: Color(0xFF171515),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
  ),
);