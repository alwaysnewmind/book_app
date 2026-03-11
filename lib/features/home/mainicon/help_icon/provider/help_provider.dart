import 'package:flutter/material.dart';
import '../models/help_faq_model.dart';
import '../services/help_service.dart';

class HelpProvider extends ChangeNotifier {

  final HelpService _service = HelpService();

  List<HelpFaqModel> _faqs = [];

  List<HelpFaqModel> get faqs => _faqs;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _expandedIndex = -1;

  int get expandedIndex => _expandedIndex;

  /// LOAD FAQS
  Future<void> loadFAQs() async {

    _isLoading = true;
    notifyListeners();

    try {
      _faqs = await _service.fetchFAQs();
    } catch (e) {
      debugPrint("FAQ load error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// TOGGLE FAQ
  void toggleFAQ(int index) {
    _expandedIndex = _expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  /// SEARCH FAQ
  List<HelpFaqModel> searchFAQs(String query) {
    if (query.isEmpty) return _faqs;

    return _faqs.where((faq) {
      return faq.question.toLowerCase().contains(query.toLowerCase()) ||
          faq.answer.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

}