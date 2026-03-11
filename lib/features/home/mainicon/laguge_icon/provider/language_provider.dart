import 'package:book_app/features/home/mainicon/laguge_icon/models/language_model.dart' show LanguageModel;
import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageProvider extends ChangeNotifier {

  final LanguageService _service = LanguageService();

  List<LanguageModel> _languages = [];

  List<LanguageModel> get languages => _languages;

  String _selectedLanguage = "en";

  String get selectedLanguage => _selectedLanguage;

  /// Load languages
  void loadLanguages() {
    _languages = _service.getLanguages();
    notifyListeners();
  }

  /// Select language
  void selectLanguage(String code) {
    _selectedLanguage = code;
    notifyListeners();
  }

  /// Check selected
  bool isSelected(String code) {
    return _selectedLanguage == code;
  }
}