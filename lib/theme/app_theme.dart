import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const darkBackgroundColor = Color(0xFF0C0C0E); // Deep Premium Black
  static const primaryAccentColor = Color(0xFF8B5CF6);  // Neon Purple
  static const secondaryGlowColor = Color(0xFFD946EF); // Neon Pink Accent
  static const glassBorderColor = Color(0xFF2E2E35);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackgroundColor,
      primaryColor: primaryAccentColor,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: primaryAccentColor,
        secondary: secondaryGlowColor,
        surface: Color(0xFF16161A),
      ),
    );
  }
}