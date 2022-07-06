import 'package:flutter/material.dart';
class Fonts {
  static const String _fontName = 'Inter';

  static TextStyle get light => const TextStyle(
    fontFamily: _fontName,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get regular => const TextStyle(
    fontFamily: _fontName,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get medium => const TextStyle(
    fontFamily: _fontName,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get bold => const TextStyle(
    fontFamily: _fontName,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get extraBold => const TextStyle(
    fontFamily: _fontName,
    fontWeight: FontWeight.w900,
  );
}

extension TextStyleHelpers on TextStyle {
  TextStyle setColor(Color color) => copyWith(color: color);
  TextStyle size(double size) => copyWith(fontSize: size);
  TextStyle letterSpacing(double spacing) => copyWith(letterSpacing: spacing);
}