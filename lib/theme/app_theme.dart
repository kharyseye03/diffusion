import 'package:flutter/material.dart';

class AppColors {
  // ── Primaire : Vert Nuit ──
  static const primary = Color(0xFF0F3D33);
  static const primaryDark = Color(0xFF0A2A23);
  static const primaryLight = Color(0xFF1C5A4C);

  // ── Accent : Or Champagne ──
  static const accent = Color(0xFFC9A84C);
  static const accentDark = Color(0xFFA8862F);
  static const accentLight = Color(0xFFE3CB86);

  // ── Neutres ──
  static const background = Color(0xFFFAF9F6); // ivoire
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF0B0B0B); // encre
  static const textSecondary = Color(0xFF6B6B63); // taupe foncé (lisible)
  static const muted = Color(0xFF9B9B91); // taupe
  static const divider = Color(0xFFE4E2DB); // taupe très clair

  // ── Sémantiques ──
  static const success = Color(0xFF2E7D5B);
  static const error = Color(0xFFB23B3B);
  static const warning = Color(0xFFC9A84C);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Manrope',
        textTheme: const TextTheme().copyWith(
          displayLarge: TextStyle(fontFamily: 'Manrope', 
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          headlineMedium: TextStyle(fontFamily: 'Manrope', 
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(fontFamily: 'Manrope', 
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontFamily: 'Manrope', 
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(fontFamily: 'Manrope', 
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontFamily: 'Manrope', 
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontFamily: 'Manrope', 
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: TextStyle(fontFamily: 'Manrope', color: AppColors.textSecondary),
          hintStyle: TextStyle(fontFamily: 'Manrope', color: AppColors.divider),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
}
