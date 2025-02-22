import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  primaryColor: Color(0xFFC86BEC),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFC86BEC),
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
  ),
);