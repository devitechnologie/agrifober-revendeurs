import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors — Agrifober green, from the web app theme
  // (`--primary: oklch(0.508 0.118 165.612)` in AgrifoberRapport).
  static const Color primary = Color(0xFF007A55);
  static const Color primaryLight = Color(0xFF009966);

  // Status
  static const Color danger = Color(0xFFD35757);
  static const Color warning = Color(0xFFFF9966);
  static const Color success = Color(0xFF6EE7B7);
  static const Color info = Color(0xFF3ABFF8);

  // Neutrals
  static const Color black = Color(0xFF1C1D23);
  static const Color black87 = Color(0xDE1C1D23);
  static const Color black54 = Color(0x8A1C1D23);

  // Backgrounds/Surfaces
  static const Color accent = Color(0xFFF9F9F9);
  static const Color gray = Color(0xFFEBEBEB);
  static const Color gray500 = Color(0xFFDDDDDD);
  static const Color gray600 = Color(0xFFCFCFCF);
  static const Color white = Color(0xFFFFFFFF);

  // Additional Colors
  static const Color green = Color(0xFF1F8931);
  static const Color gold = Color(0xFFFFC00A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryLight, primary],
  );
}
