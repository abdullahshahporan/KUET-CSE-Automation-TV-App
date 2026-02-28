import 'package:flutter/material.dart';

/// Dark TV-optimised theme — professional broadcast channel aesthetic.
class TVTheme {
  TVTheme._();

  // ── Core palette ────────────────────────────────────────
  static const Color background = Color(0xFF080A0E);
  static const Color surface = Color(0xFF111520);
  static const Color surfaceVariant = Color(0xFF171C28);
  static const Color surfaceElevated = Color(0xFF1C2235);
  static const Color border = Color(0xFF2A3245);
  static const Color borderLight = Color(0xFF384460);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB1A7A6);
  static const Color accent = Color(0xFFBA181B);
  static const Color accentLight = Color(0xFFE5383B);
  static const Color accentGlow = Color(0xFFFF2D2D);
  static const Color silver = Color(0xFFD3D3D3);

  // ── Broadcast / Channel colours ────────────────────────
  static const Color liveRed = Color(0xFFFF0000);
  static const Color breakingOrange = Color(0xFFFF6B00);
  static const Color specialBlue = Color(0xFF0A84FF);
  static const Color tickerBg = Color(0xFF0D1117);
  static const Color headerGradientStart = Color(0xFF0F1923);
  static const Color headerGradientEnd = Color(0xFF1A1020);
  static const Color gold = Color(0xFFFFD700);
  static const Color cyan = Color(0xFF00D4FF);

  // ── Priority colours ───────────────────────────────────
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityLow = Color(0xFF10B981);

  // ── Type badge colours ─────────────────────────────────
  static const Color typeClassTest = Color(0xFFBA181B);
  static const Color typeAssignment = Color(0xFF3B82F6);
  static const Color typeNotice = Color(0xFF9CA3AF);
  static const Color typeEvent = Color(0xFFEC4899);
  static const Color typeLabTest = Color(0xFFD3D3D3);
  static const Color typeQuiz = Color(0xFFF97316);

  // ── ThemeData ──────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          surface: surface,
          primary: accent,
          secondary: accentLight,
          onSurface: textPrimary,
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: border, width: 1),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: textSecondary),
          bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
          bodySmall: TextStyle(fontSize: 12, color: textSecondary),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        dividerColor: border,
        iconTheme: const IconThemeData(color: textSecondary, size: 24),
      );
}
