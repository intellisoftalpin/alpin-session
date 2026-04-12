import 'package:flutter/material.dart';
import 'alpin_colors.dart';

const _fontFamily = '.SF Pro Text';

class AlpinTheme {
  AlpinTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AlpinColors.alpineBlue,
        primaryContainer: AlpinColors.deepGlacier,
        secondary: AlpinColors.pineGreen,
        surface: AlpinColors.snowWhite,
        error: AlpinColors.alpineRose,
        onPrimary: Colors.white,
        onSurface: AlpinColors.granite,
        outline: AlpinColors.mistGrey,
        tertiary: AlpinColors.meadowGold,
      ),
      scaffoldBackgroundColor: AlpinColors.cloudWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: AlpinColors.cloudWhite,
        foregroundColor: AlpinColors.granite,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AlpinColors.granite,
        ),
      ),
      cardTheme: CardThemeData(
        color: AlpinColors.snowWhite,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AlpinColors.alpineBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AlpinColors.alpineBlue,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AlpinColors.alpineBlue),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AlpinColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AlpinColors.alpineBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AlpinColors.lightSurface,
        thickness: 1,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AlpinColors.glacierLight,
        primaryContainer: AlpinColors.iceBlue,
        secondary: AlpinColors.forestLight,
        surface: AlpinColors.nightRock,
        error: AlpinColors.roseLight,
        onPrimary: Colors.white,
        onSurface: AlpinColors.snowfield,
        outline: AlpinColors.stoneGrey,
        tertiary: AlpinColors.starGold,
      ),
      scaffoldBackgroundColor: AlpinColors.deepNight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AlpinColors.deepNight,
        foregroundColor: AlpinColors.snowfield,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AlpinColors.snowfield,
        ),
      ),
      cardTheme: CardThemeData(
        color: AlpinColors.nightRock,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AlpinColors.glacierLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AlpinColors.glacierLight,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AlpinColors.glacierLight),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AlpinColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AlpinColors.glacierLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AlpinColors.darkSurface,
        thickness: 1,
      ),
    );
  }
}
