import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); // Private constructor

  // ====================== MAIN APP THEME (DARK FUTURISTIC) ======================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF00E5C0), // Cyan accent
    scaffoldBackgroundColor: const Color(0xFF051024),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00E5C0),
      secondary: Color(0xFF00C4B4),
      background: Color(0xFF051024),
      surface: Color(0xFF0A1F38),
      error: Color(0xFFEF5350),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),

    // Text Theme with Orbitron (futuristic feel)
    textTheme: GoogleFonts.orbitronTextTheme().copyWith(
      displayLarge: GoogleFonts.orbitron(
          fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: GoogleFonts.orbitron(
          fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: GoogleFonts.orbitron(
          fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: GoogleFonts.orbitron(
          fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: GoogleFonts.orbitron(fontSize: 15.sp, color: Colors.white70),
      bodyMedium: GoogleFonts.orbitron(fontSize: 14.sp, color: Colors.white70),
      labelLarge: GoogleFonts.orbitron(
          fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF051024),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.orbitron(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.2,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00E5C0),
        foregroundColor: Colors.black,
        elevation: 4,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle:
            GoogleFonts.orbitron(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0A1F38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide:
            BorderSide(color: Colors.cyanAccent.withOpacity(0.6), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFF00E5C0), width: 2),
      ),
    ),
  );
}
