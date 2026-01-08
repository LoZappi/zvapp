import 'package:flutter/material.dart';
import '../ui/theme/zv_colors.dart';

class ZVTheme {
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: ZVColors.background,

      colorScheme: base.colorScheme.copyWith(
        primary: ZVColors.primary,
        surface: ZVColors.card,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: ZVColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: ZVColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: ZVColors.textPrimary),
      ),

      textTheme: base.textTheme.apply(
        bodyColor: ZVColors.textPrimary,
        displayColor: ZVColors.textPrimary,
      ),

      cardTheme: CardThemeData(
        color: ZVColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ZVColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ZVColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ZVColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ZVColors.primary.withValues(alpha: 0.8), width: 1.6),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ZVColors.primary;
          return Colors.transparent;
        }),
        side: BorderSide(color: ZVColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ZVColors.primary;
          return ZVColors.border;
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ZVColors.primary,
          foregroundColor: ZVColors.textPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ZVColors.textPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: ZVColors.border),
        ),
      ),
    );
  }
}
