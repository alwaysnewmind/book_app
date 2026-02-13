import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._(); // private constructor to prevent instantiation

  // 🔹 Radius values
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;

  // 🔹 BorderRadius
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(lg));
}
