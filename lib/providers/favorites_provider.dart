import 'package:book_app/config/app_config.dart';
import 'package:book_app/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;
  List<BookModel> _favoriteBooks = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<BookModel> get favoriteBooks => List.unmodifiable(_favoriteBooks);

  Future<void> loadFavorites({String userId = 'reader_1'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _favoriteBooks = isDummyMode
          ? await _loadDummyFavorites()
          : await _loadFirestoreFavorites(userId: userId);
    } catch (e) {
      _error = 'Failed to load favorites. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshFavorites({String userId = 'reader_1'}) async {
    try {
      _error = null;
      _favoriteBooks = isDummyMode
          ? await _loadDummyFavorites()
          : await _loadFirestoreFavorites(userId: userId);
      notifyListeners();
    } catch (_) {
      _error = 'Refresh failed. Pull down to retry.';
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String bookId, {String userId = 'reader_1'}) async {
    final existing = _favoriteBooks.where((book) => book.id == bookId).toList();
    if (existing.isEmpty) return;

    final removedBook = existing.first;
    _favoriteBooks.removeWhere((book) => book.id == bookId);
    notifyListeners();

    try {
      if (isDummyMode) {
        await Future<void>.delayed(const Duration(milliseconds: 120));
      } else {
        await _deleteBookmark(userId: userId, bookId: bookId);
      }
    } catch (_) {
      _favoriteBooks = [removedBook, ..._favoriteBooks]
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
      _error = 'Could not remove favorite. Please retry.';
      notifyListeners();
    }
  }

  Future<List<BookModel>> _loadDummyFavorites() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _dummyBooks
        .where((book) => book.isBookmarked)
        .toList()
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<List<BookModel>> _loadFirestoreFavorites({required String userId}) async {
    final bookmarks = await _fetchBookmarkedIds(userId: userId);
    if (bookmarks.isEmpty) return [];

    final details = await _fetchBooksByIds(bookmarks.keys.toList());
    final merged = <BookModel>[];

    for (final entry in bookmarks.entries) {
      final book = details[entry.key];
      if (book == null) continue;
      merged.add(book.copyWith(savedAt: entry.value, isBookmarked: true));
    }

    merged.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return merged;
  }

  Future<Map<String, DateTime>> _fetchBookmarkedIds({required String userId}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .get();

    final result = <String, DateTime>{};
    for (final doc in snapshot.docs) {
      final savedAtRaw = doc.data()['savedAt'];
      final savedAt = savedAtRaw is Timestamp
          ? savedAtRaw.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0);
      result[doc.id] = savedAt;
    }

    return result;
  }

  Future<Map<String, BookModel>> _fetchBooksByIds(List<String> bookIds) async {
    final result = <String, BookModel>{};
    for (final bookId in bookIds) {
      final doc = await _firestore.collection('books').doc(bookId).get();
      if (!doc.exists) continue;
      result[bookId] = BookModel.fromFirestore(
        id: doc.id,
        bookData: doc.data() ?? <String, dynamic>{},
      );
    }
    return result;
  }

  Future<void> _deleteBookmark({required String userId, required String bookId}) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookId)
        .delete();
  }
}

final List<BookModel> _dummyBooks = [
  BookModel(
    id: 'book_1',
    title: 'The Midnight Library',
    description: 'A moving novel about life choices and alternate paths.',
    authorName: 'Matt Haig',
    coverUrl: 'assets/books/Book1.png',
    genre: 'Fiction',
    rating: 4.6,
    reviewCount: 1320,
    isPaid: false,
    price: 0,
    viewsCount: 20212,
    isBookmarked: true,
    savedAt: DateTime(2026, 1, 18),
  ),
  BookModel(
    id: 'book_2',
    title: 'Project Hail Mary',
    description: 'A science adventure about survival and friendship in space.',
    authorName: 'Andy Weir',
    coverUrl: 'assets/books/Book2.png',
    genre: 'Sci-Fi',
    rating: 4.8,
    reviewCount: 910,
    isPaid: true,
    price: 149,
    viewsCount: 18211,
    isBookmarked: true,
    savedAt: DateTime(2026, 1, 15),
  ),
  BookModel(
    id: 'book_3',
    title: 'Circe',
    description: 'A mythical retelling centered on identity and transformation.',
    authorName: 'Madeline Miller',
    coverUrl: 'assets/books/Book3.png',
    genre: 'Mythology',
    rating: 4.5,
    reviewCount: 760,
    isPaid: false,
    price: 0,
    viewsCount: 12620,
    isBookmarked: true,
    savedAt: DateTime(2026, 1, 10),
  ),
  BookModel(
    id: 'book_4',
    title: 'The Vanishing Half',
    description: 'A layered family saga with race, identity, and belonging.',
    authorName: 'Brit Bennett',
    coverUrl: 'assets/books/Book4.png',
    genre: 'Drama',
    rating: 4.4,
    reviewCount: 643,
    isPaid: true,
    price: 99,
    viewsCount: 9380,
    isBookmarked: false,
    savedAt: DateTime(2026, 1, 7),
  ),
];
