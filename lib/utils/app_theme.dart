import 'package:flutter/material.dart';

/// Paleta de colores y estilos de diseño "Quiet Luxury"
/// Basado en DESIGN.md de la carpeta de diseño
class AppTheme {
  // Colores principales
  static const Color surface = Color(0xFFFAF9F7);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFF4F3F1);
  static const Color surfaceContainer = Color(0xFFEFEEEC);
  static const Color surfaceContainerHigh = Color(0xFFE9E8E6);
  static const Color surfaceDim = Color(0xFFDADAD8);

  // Tipografía y acentos
  static const Color primaryObsidian = Color(0xFF16171A);
  static const Color secondarySlate = Color(0xFF4A4D53);
  static const Color tertiaryCashmere = Color(0xFF8A8D93);
  static const Color outline = Color(0xFF76777B);
  static const Color outlineHairline = Color(0xFFE5E2DC);

  // Estados financieros
  static const Color incomeGreen = Color(0xFF2D4F3E); // Deep cypress green
  static const Color expenseRed = Color(0xFF782E2E); // Cordovan wine

  // Radios de borde
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusFull = 999.0;

  // Tema claro (Quiet Luxury)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.light(
        surface: surface,
        primary: primaryObsidian,
        onPrimary: Colors.white,
        secondary: secondarySlate,
        onSecondary: Colors.white,
        error: expenseRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryObsidian,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: primaryObsidian),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: outlineHairline, width: 1),
        ),
      ),
      fontFamily: 'sans-serif',
    );
  }

  // Tema oscuro (Obsidian Luxury)
  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF121315);
    const darkCard = Color(0xFF1B1C1F);
    const darkBorder = Color(0xFF2A2B2E);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        primary: Colors.white,
        onPrimary: Color(0xFF121315),
        secondary: Color(0xFFA0A3A8),
        onSecondary: Colors.white,
        error: Color(0xFFCF6679),
        onError: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      fontFamily: 'sans-serif',
    );
  }
}
