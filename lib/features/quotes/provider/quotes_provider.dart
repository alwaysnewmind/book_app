import 'package:book_app/features/quotes/models/quote_model.dart';
import 'package:book_app/features/quotes/services/quotes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

class QuotesProvider extends ChangeNotifier {
  QuotesProvider({QuotesService? service}) : _service = service ?? QuotesService() {
    _initialize();
  }

  final QuotesService _service;

  bool isLoading = false;
  String? errorMessage;
  String selectedCategory = 'Emotional';
  List<String> categories = <String>[];
  List<QuoteModel> allQuotes = <QuoteModel>[];
  List<QuoteModel> filteredQuotes = <QuoteModel>[];

  bool _didInitialize = false;

  Future<void> _initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>(<Future<dynamic>>[
        _service.fetchQuotes(),
        _service.fetchCategories(),
      ]);

      allQuotes = results[0] as List<QuoteModel>;
      final backendCategories = results[1] as List<String>;

      categories = <String>{
        'Emotional',
        'Motivational',
        'Love',
        'Success',
        'Life',
        ...backendCategories,
      }.toList();

      if (!categories.contains(selectedCategory) && categories.isNotEmpty) {
        selectedCategory = categories.first;
      }

      filterQuotes();
    } catch (e) {
      errorMessage = 'Failed to load quotes. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      errorMessage = null;
      final backendCategories = await _service.fetchCategories();
      categories = <String>{
        'Emotional',
        'Motivational',
        'Love',
        'Success',
        'Life',
        ...backendCategories,
      }.toList();

      if (!categories.contains(selectedCategory) && categories.isNotEmpty) {
        selectedCategory = categories.first;
      }
      filterQuotes();
    } catch (e) {
      errorMessage = 'Failed to load categories.';
      notifyListeners();
    }
  }

  Future<void> fetchQuotes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      allQuotes = await _service.fetchQuotes();
      filterQuotes();
    } catch (e) {
      errorMessage = 'Failed to load quotes. Please try again.';
      filteredQuotes = <QuoteModel>[];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void changeCategory(String category) {
    selectedCategory = category;
    filterQuotes();
  }

  Future<void> addQuote(QuoteModel quote) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _service.addQuote(quote);
      await fetchQuotes();
      await fetchCategories();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to add quote.';
      notifyListeners();
    }
  }

  Future<void> toggleLike(String quoteId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      errorMessage = 'Please login to like a quote.';
      notifyListeners();
      return;
    }

    final quoteIndex = allQuotes.indexWhere((q) => q.id == quoteId);
    if (quoteIndex == -1) {
      return;
    }

    final quote = allQuotes[quoteIndex];
    try {
      final isNowLiked = await _service.toggleLike(
        quoteId: quoteId,
        userId: userId,
      );

      final updatedLikedBy = List<String>.from(quote.likedBy);
      if (isNowLiked) {
        if (!updatedLikedBy.contains(userId)) {
          updatedLikedBy.add(userId);
        }
      } else {
        updatedLikedBy.remove(userId);
      }

      allQuotes[quoteIndex] = quote.copyWith(
        likedBy: updatedLikedBy,
        likes: isNowLiked ? quote.likes + 1 : math.max(quote.likes - 1, 0),
      );

      filterQuotes();
    } catch (e) {
      errorMessage = 'Unable to update like right now.';
      notifyListeners();
    }
  }

  void filterQuotes() {
    filteredQuotes = allQuotes
        .where((q) => q.category == selectedCategory)
        .toList();

    notifyListeners();
  }
}
