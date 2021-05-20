import 'package:flutter/material.dart';

class Themes {
  static ThemeData defaultTheme() => ThemeData.from(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          // Background Swatch
          surface: const Color(0xFFF8F8F8),
          background: const Color(0xFFEFEFEF),
          onBackground: const Color(0xFF333333),
          onSurface: const Color(0xFF333333),
          // Primary Swatch
          primary: const Color(0xFFD05664),
          primaryVariant: const Color(0xFFDB3043),
          onPrimary: const Color(0xFFFFFFFF),
          // Secondary Swatch
          secondary: const Color(0xFF4EA3B8),
          secondaryVariant: const Color(0xFF358EAB),
          onSecondary: const Color(0xFFFFFFFF),
          // Error Swatch
          error: const Color(0xFFF12323),
          onError: const Color(0xFF000000),
        ),
        textTheme: TextTheme(),
      );
}
