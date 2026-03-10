import 'package:flutter/material.dart';

/// Solo Leveling inspired color palette
class AppColors {
  // ═══════════════════════════════════════════════════
  // Primary Colors (Blue theme from Solo Leveling)
  // ═══════════════════════════════════════════════════
  static const Color primary = Color(0xFF00D4FF);      // Bright cyan blue
  static const Color primaryDark = Color(0xFF0088CC);  // Darker blue
  static const Color primaryLight = Color(0xFF66E4FF); // Light cyan

  // ═══════════════════════════════════════════════════
  // Background Colors (Dark theme)
  // ═══════════════════════════════════════════════════
  static const Color background = Color(0xFF0A0E1A);   // Very dark blue-black
  static const Color surface = Color(0xFF151B2D);      // Slightly lighter surface
  static const Color surfaceLight = Color(0xFF1E2638); // Even lighter surface

  // ═══════════════════════════════════════════════════
  // Text Colors
  // ═══════════════════════════════════════════════════
  static const Color textPrimary = Color(0xFFFFFFFF);  // White
  static const Color textSecondary = Color(0xFFB8C5D6); // Light gray-blue
  static const Color textDisabled = Color(0xFF6B7A94); // Darker gray

  // ═══════════════════════════════════════════════════
  // Accent Colors
  // ═══════════════════════════════════════════════════
  static const Color accent = Color(0xFFFFD700);       // Gold
  static const Color accentDanger = Color(0xFFFF4757); // Red
  static const Color accentSuccess = Color(0xFF1DD1A1); // Green
  static const Color accentWarning = Color(0xFFFFA502); // Orange

  // ═══════════════════════════════════════════════════
  // Quest Status Colors
  // ═══════════════════════════════════════════════════
  static const Color questIncomplete = Color(0xFF2E3A52); // Gray-blue
  static const Color questInProgress = Color(0xFF00A8CC); // Blue
  static const Color questCompleted = Color(0xFF1DD1A1);  // Green

  // ═══════════════════════════════════════════════════
  // Stat Colors (for different attributes)
  // ═══════════════════════════════════════════════════
  static const Color strengthColor = Color(0xFFFF6B6B);     // Red
  static const Color agilityColor = Color(0xFF4ECDC4);      // Teal
  static const Color intelligenceColor = Color(0xFF95E1D3); // Mint
  static const Color vitalityColor = Color(0xFFF38181);     // Pink

  // ═══════════════════════════════════════════════════
  // Glow/Shadow Effects
  // ═══════════════════════════════════════════════════
  static const Color glowPrimary = Color(0x4400D4FF);  // Semi-transparent blue
  static const Color glowGold = Color(0x44FFD700);     // Semi-transparent gold

  // ═══════════════════════════════════════════════════
  // Glass Effect
  // ═══════════════════════════════════════════════════
  static const Color glassBackground = Color(0x33FFFFFF); // Semi-transparent white
  static const Color glassBorder = Color(0x66FFFFFF);     // More opaque white

  // ═══════════════════════════════════════════════════
  // Gradient Colors
  // ═══════════════════════════════════════════════════
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFB800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, Color(0xFF0F1524)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ═══════════════════════════════════════════════════
  // Box Shadow (Glow Effects)
  // ═══════════════════════════════════════════════════
  static BoxShadow primaryGlow = BoxShadow(
    color: glowPrimary,
    blurRadius: 20,
    spreadRadius: 2,
  );

  static BoxShadow goldGlow = BoxShadow(
    color: glowGold,
    blurRadius: 15,
    spreadRadius: 1,
  );

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
