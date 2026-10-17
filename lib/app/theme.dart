import 'package:flutter/material.dart';

const paper = Color(0xFFFFFBEF);
const ink = Color(0xFF333D38);
const rule = Color(0xFFD9D4C4);

ThemeData plannerTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: ink, surface: paper),
  scaffoldBackgroundColor: const Color(0xFFE8E2D5),
  appBarTheme: const AppBarTheme(backgroundColor: paper, foregroundColor: ink),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontFamily: 'serif', color: ink, fontSize: 28),
    titleLarge: TextStyle(fontFamily: 'serif', color: ink, fontSize: 22),
    bodyLarge: TextStyle(color: ink, height: 1.6),
  ),
  dividerTheme: const DividerThemeData(color: rule, thickness: 1),
  inputDecorationTheme: const InputDecorationTheme(
    border: UnderlineInputBorder(),
  ),
);
