import 'package:flutter/material.dart';

class IskolarSafeTheme {
  static const bool _useMaterialYou = true;
  static const Color _mainColor = Color(0xFF8A1538);

  static ThemeData lightTheme = ThemeData(
      useMaterial3: _useMaterialYou,
      colorSchemeSeed: _mainColor,
      brightness: Brightness.light);
  static ThemeData darkTheme = ThemeData(
    useMaterial3: _useMaterialYou,
    colorSchemeSeed: _mainColor,
    brightness: Brightness.dark,
  );

  static const VisualDensity listTileDensity = VisualDensity(vertical: 1);
  static const double listTileIconSize = 24.0;

  bool isDark(themeData) => themeData == darkTheme;
}
