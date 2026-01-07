import 'package:flutter/material.dart';

class ZVColors {
  // ===== Brand =====
  static const Color primary = Color(0xFFFFD200);
  static const Color yellow = primary; // alias vecchio
  static const Color primarySoft = Color(0xFFFFF4CC);

  // ===== Background / Surfaces =====
  static const Color background = Color(0xFFEEF1F4); // ✅ riposante
  static const Color surface = Color(0xFFF6F7F9);    // ✅ appbar soft

  // ===== Card =====
  static const Color card = Color(0xFFFFFFFF); // ✅ card bianche che staccano

  // ===== Text =====
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF6B7280);

  // alias vecchi
  static const Color dark = textPrimary;
  static const Color muted = textSecondary;

  // ===== Border =====
  static const Color border = Color(0xFFE5E7EB);
}
