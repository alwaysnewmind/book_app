import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  void changeLanguage(String code) {
    _locale = Locale(code);
    notifyListeners();
  }

  bool isSelected(String code) {
    return _locale.languageCode == code;
  }
}
