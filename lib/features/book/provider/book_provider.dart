import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:book_app/config/app_config.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/models/writer_book_model.dart';

class BookProvider extends ChangeNotifier {
  BookProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;
  List<Book> _books = [];

  /// =============================
  /// GETTERS
  /// =============================

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<Book> get books => List.unmodifiable(_books);

  /// =============================
  /// LOAD BOOKS
  /// =============================

  Future<void> loadBooks() async {
    _setLoading(true);
    _error = null;

    try {
      if (isDummyMode) {
        _books = await _loadDummyBooks();
      } else {
        _books = await _loadFirebaseBooks();
      }
    } catch (e) {
      debugPrint("Load books error: $e");
      _error = 'Unable to load books right now.';
    }

    _setLoading(false);
  }

  /// =============================
  /// DUMMY DATA
  /// =============================

  Future<List<Book>> _loadDummyBooks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return dummyBooks;
  }

  /// =============================
  /// FIREBASE DATA
  /// =============================

  Future<List<Book>> _loadFirebaseBooks() async {
    final snapshot = await _firestore.collection('books').get();

    return snapshot.docs
        .map((doc) => _bookFromMap(doc))
        .toList();
  }

  /// =============================
  /// REALTIME STREAM
  /// =============================

  Stream<List<Book>> booksStream() {
    if (isDummyMode) {
      return Stream.value(dummyBooks);
    }

    return _firestore.collection('books').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map((doc) => _bookFromMap(doc))
            .toList();
      },
    );
  }

  /// =============================
  /// MAP FIRESTORE DATA
  /// =============================

  Book _bookFromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};

    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      authorId: map['authorId']?.toString() ?? '',
      coverImage:
          map['coverImage']?.toString() ?? 'assets/books/Book1.png',
      summary:
          map['description']?.toString() ??
          map['summary']?.toString() ??
          '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      genre: map['genre']?.toString() ?? 'General',
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
    );
  }

  /// =============================
  /// HELPERS
  /// =============================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}