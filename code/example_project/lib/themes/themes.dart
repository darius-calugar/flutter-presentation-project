import 'package:flutter/material.dart';

class Themes {
  static ThemeData defaultTheme() => ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          // Background Swatch
          surface: const Color(0xFFFFFFFF),
          background: const Color(0xFFEEEEEE),
          onBackground: const Color(0xFF2A2A30),
          onSurface: const Color(0xFF2A2A30),
          // Primary Swatch
          primary: const Color(0xFFD75650),
          primaryVariant: const Color(0xFFCD4944),
          onPrimary: const Color(0xFFFFFFFF),
          // Secondary Swatch
          secondary: const Color(0xFF96B3F6),
          secondaryVariant: const Color(0xFF809CDD),
          onSecondary: const Color(0xFFFFFFFF),
          // Error Swatch
          error: const Color(0xFFBC2626),
          onError: const Color(0xFFFFFFFF),
        ),
        textTheme: TextTheme(),
      ).copyWith(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: const Color(0xFF2A2A30),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF2A2A30),
          selectedItemColor: const Color(0xFFD75650),
          unselectedItemColor: const Color(0xFFFFFFFF),
        ),
      );
}
