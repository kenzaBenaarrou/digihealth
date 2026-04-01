import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._(); // Prevent instantiation

  // --- 1. LIGHT PALETTE ---
  static const Color _lightPrimary = Color(0xFF0D47A1); // DigiHealth Blue
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _lightSurface = Colors.white;
  static const Color _lightText = Color(0xFF1A1D1E);
  static const Color _lightError = Color(0xFFD32F2F);

  // --- 2. DARK PALETTE ---
  static const Color _darkPrimary = Color(0xFF64B5F6); // Lighter blue for dark mode
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkText = Color(0xFFE3E3E3);
  static const Color _darkError = Color(0xFFEF5350);

  // --- 3. LIGHT THEME DATA ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        background: _lightBackground,
        surface: _lightSurface,
        error: _lightError,
        onPrimary: Colors.white,
        onBackground: _lightText,
        onSurface: _lightText,
      ),
      scaffoldBackgroundColor: _lightBackground,
      // Integrate Google Fonts with ScreenUtil for responsive text
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: _lightText),
        bodyMedium: TextStyle(fontSize: 14.sp, color: _lightText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }

  // --- 4. DARK THEME DATA ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        background: _darkBackground,
        surface: _darkSurface,
        error: _darkError,
        onPrimary: Colors.black,
        onBackground: _darkText,
        onSurface: _darkText,
      ),
      scaffoldBackgroundColor: _darkBackground,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: _darkText),
        bodyMedium: TextStyle(fontSize: 14.sp, color: _darkText),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkPrimary,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
}