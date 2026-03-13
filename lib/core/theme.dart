import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF6366F1); // Vibrant Indigo
  static const Color secondary = Color(0xFFA855F7); // Rich Purple
  static const Color accent = Color(0xFFFBBF24); // Amber/Gold accent
  static const Color luxuryGold = Color(0xFFD4AF37); // Deep Gold
  static const Color background = Color(0xFF020617); // Deepest Navy
  static const Color surface = Color(0xFF0F172A); // Slate Navy
  static const Color cardBg = Color(0x1AFFFFFF); // Glassmorphism white 10%
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color glassBorder = Color(0x1FFFFFFF); // 12% white border

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      surface: surface,
      onSurface: textPrimary,
    ),
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) => null), // Handled by decoration
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: glassBorder.withOpacity(0.1), width: 1),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: glassBorder.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: glassBorder.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
  );
}
