import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the default theme for the app
final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 113, 243, 230),
    elevation: 4,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0097A7),
    secondary: Color(0xFF009688),
    background: Color(0xFFE0F2F1),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
//add a dark theme to the app
final darkTheme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 113, 243, 230),
    elevation: 4,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0097A7),
    secondary: Color(0xFF009688),
    background: Color(0xFFE0F2F1),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
  Future<bool> isDark() async {
    

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("is_dark") ?? false;
  }

  Future<void> setTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_dark", !isDark);
  }
