import 'package:book_app/features/home/mainicon/quotes icon/models/quote_model.dart';
import 'package:book_app/features/home/mainicon/quotes icon/services/quotes_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

class QuotesProvider extends ChangeNotifier {
  QuotesProvider({QuotesService? service})
      : _service = service ?? QuotesService() {
    _initialize();
  }

  final QuotesService _service;

  bool isLoading = false;
  String? errorMessage;

  String selectedCategory = "Emotional";

  List<String> categories = [];
  List<QuoteModel> allQuotes = [];
  List<QuoteModel> filteredQuotes = [];

  bool _didInitialize = false;

  /// 🔥 INITIAL LOAD
  Future<void> _initialize() async {
    if (_didInitialize) return;
    _didInitialize = true;

    isLoading = true;
    notifyListeners();

    try {
      final quotes = await _service.fetchQuotes();
      final backendCategories = await _service.fetchCategories();

      allQuotes = quotes;

      categories = {
        "Emotional",
        "Motivational",
        "Love",
        "Success",
        "Life",
        ...backendCategories
      }.toList();

      if (!categories.contains(selectedCategory) && categories.isNotEmpty) {
        selectedCategory = categories.first;
      }

      filterQuotes();
    } catch (e) {
      errorMessage = "Failed to load quotes";
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔥 FETCH QUOTES
  Future<void> fetchQuotes() async {
    try {
      isLoading = true;
      notifyListeners();

      allQuotes = await _service.fetchQuotes();
      filterQuotes();
    } catch (e) {
      errorMessage = "Failed to load quotes";
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔥 FETCH CATEGORIES
  Future<void> fetchCategories() async {
    try {
      final backendCategories = await _service.fetchCategories();

      categories = {
        "Emotional",
        "Motivational",
        "Love",
        "Success",
        "Life",
        ...backendCategories
      }.toList();

      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to load categories";
      notifyListeners();
    }
  }

  /// 🔥 CATEGORY CHANGE
  void changeCategory(String category) {
    selectedCategory = category;
    filterQuotes();
  }

  /// 🔥 ADD QUOTE
  Future<void> addQuote(QuoteModel quote) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.addQuote(quote);

      await fetchQuotes();
      await fetchCategories();
    } catch (e) {
      errorMessage = "Failed to add quote";
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔥 LIKE / UNLIKE
  Future<void> toggleLike(String quoteId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      errorMessage = "Please login first";
      notifyListeners();
      return;
    }

    final index = allQuotes.indexWhere((q) => q.id == quoteId);

    if (index == -1) return;

    final quote = allQuotes[index];

    try {
      final isLiked = await _service.toggleLike(
        quoteId: quoteId,
        userId: userId,
      );

      final likedBy = List<String>.from(quote.likedBy);

      if (isLiked) {
        likedBy.add(userId);
      } else {
        likedBy.remove(userId);
      }

      allQuotes[index] = quote.copyWith(
        likedBy: likedBy,
        likes: isLiked ? quote.likes + 1 : math.max(quote.likes - 1, 0),
      );

      filterQuotes();
    } catch (e) {
      errorMessage = "Unable to update like";
      notifyListeners();
    }
  }

  /// 🔥 FILTER
  void filterQuotes() {
    filteredQuotes =
        allQuotes.where((q) => q.category == selectedCategory).toList();

    notifyListeners();
  }
}