import 'dart:math';

import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const bool isDummyMode = true;

class ReaderStudioProvider extends ChangeNotifier {
  ReaderStudioProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _errorMessage;
  List<ReaderBookModel> _books = <ReaderBookModel>[];
  ReaderStatsSummary _stats = ReaderStatsSummary.empty();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ReaderStatsSummary get stats => _stats;

  List<ReaderBookModel> get allBooks => List<ReaderBookModel>.unmodifiable(_books);

  List<ReaderBookModel> getContinueReading() {
    final filtered = _books
        .where((book) => book.progressPercent > 0 && book.progressPercent < 100)
        .toList()
      ..sort((a, b) => (b.lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return filtered.take(5).toList();
  }

  List<ReaderBookModel> getRecentlyRead() {
    final recent = List<ReaderBookModel>.from(_books)
      ..sort((a, b) => (b.lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.lastReadAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
    return recent.take(10).toList();
  }

  List<ReaderBookModel> getRecommendedBooks() {
    if (_books.isEmpty) return <ReaderBookModel>[];

    if (isDummyMode) {
      final recentlyRead = getRecentlyRead();
      final preferredGenres = recentlyRead.take(3).map((book) => book.genre).toSet();
      final byGenre = _books.where((book) => preferredGenres.contains(book.genre)).toList();
      if (byGenre.isNotEmpty) {
        return byGenre.take(6).toList();
      }

      final randomized = List<ReaderBookModel>.from(_books)..shuffle(Random());
      return randomized.take(6).toList();
    }

    final ranked = List<ReaderBookModel>.from(_books)
      ..sort((a, b) {
        final ratingSort = b.rating.compareTo(a.rating);
        if (ratingSort != 0) return ratingSort;
        return b.viewsCount.compareTo(a.viewsCount);
      });
    return ranked.take(6).toList();
  }

  List<ReaderBookModel> getQuickAccessFavorites() {
    return _books.where((book) => book.isBookmarked).toList();
  }

  Future<void> loadReaderStudioData({required String? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _books = isDummyMode
          ? _getDummyBooks()
          : await _fetchReaderStudioDataFromFirestore(userId: userId);
      _stats = calculateReadingStats();
    } catch (error, _) {
      _errorMessage = 'Failed to load Reader Studio data. Please try again.';
      _books = <ReaderBookModel>[];
      _stats = ReaderStatsSummary.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark({required String bookId, required String? userId}) async {
    try {
      final index = _books.indexWhere((book) => book.id == bookId);
      if (index < 0) return;

      final updatedBook = _books[index].copyWith(isBookmarked: !_books[index].isBookmarked);
      _books[index] = updatedBook;

      if (!isDummyMode && userId != null) {
        await _updateBookmarkInFirestore(userId: userId, book: updatedBook);
      }

      notifyListeners();
    } catch (error, _) {
      _errorMessage = 'Unable to update bookmark right now.';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateReadingProgress({
    required String bookId,
    required int chapter,
    required String? userId,
  }) async {
    try {
      final index = _books.indexWhere((book) => book.id == bookId);
      if (index < 0) return;

      final selectedBook = _books[index];
      final safeChapter = chapter.clamp(0, selectedBook.totalChapters);
      final progressPercent = selectedBook.totalChapters == 0
          ? 0
          : (safeChapter / selectedBook.totalChapters) * 100;

      _books[index] = selectedBook.copyWith(
        lastReadChapter: safeChapter,
        progressPercent: progressPercent,
        lastReadAt: DateTime.now(),
      );

      _stats = calculateReadingStats();

      if (!isDummyMode && userId != null) {
        await _updateReadingProgressInFirestore(
          userId: userId,
          bookId: bookId,
          chapter: safeChapter,
          progressPercent: progressPercent,
        );
      }

      notifyListeners();
    } catch (error, _) {
      _errorMessage = 'Unable to update reading progress.';
      notifyListeners();
      rethrow;
    }
  }

  ReaderStatsSummary calculateReadingStats() {
    if (_books.isEmpty) return ReaderStatsSummary.empty();

    final completedBooks = _books.where((book) => book.progressPercent >= 100).length;
    final currentlyReading =
        _books.where((book) => book.progressPercent > 0 && book.progressPercent < 100).length;
    final totalProgress = _books.fold<double>(0, (sum, book) => sum + book.progressPercent);

    return ReaderStatsSummary(
      totalBooksRead: _books.where((book) => book.lastReadChapter > 0).length,
      completedBooks: completedBooks,
      currentlyReading: currentlyReading,
      averageProgress: totalProgress / _books.length,
    );
  }

  List<ReaderBookModel> _getDummyBooks() {
    final now = DateTime.now();
    return <ReaderBookModel>[
      ReaderBookModel(
        id: 'atomic_habits',
        title: 'Atomic Habits',
        description: 'Build better habits and break bad ones.',
        authorName: 'James Clear',
        coverUrl: 'assets/covers/atomic.jpg',
        genre: 'Self Help',
        rating: 4.8,
        totalChapters: 20,
        lastReadChapter: 12,
        progressPercent: 60,
        viewsCount: 9320,
        isBookmarked: true,
        lastReadAt: now.subtract(const Duration(hours: 5)),
      ),
      ReaderBookModel(
        id: 'rich_dad',
        title: 'Rich Dad Poor Dad',
        description: 'A mindset shift about money and wealth.',
        authorName: 'Robert Kiyosaki',
        coverUrl: 'assets/covers/richdad.jpg',
        genre: 'Finance',
        rating: 4.6,
        totalChapters: 18,
        lastReadChapter: 7,
        progressPercent: 38.9,
        viewsCount: 7810,
        isBookmarked: false,
        lastReadAt: now.subtract(const Duration(days: 1)),
      ),
      ReaderBookModel(
        id: 'deep_work',
        title: 'Deep Work',
        description: 'Rules for focused success in a distracted world.',
        authorName: 'Cal Newport',
        coverUrl: 'assets/covers/deepwork.jpg',
        genre: 'Productivity',
        rating: 4.7,
        totalChapters: 16,
        lastReadChapter: 0,
        progressPercent: 0,
        viewsCount: 5400,
        isBookmarked: true,
        lastReadAt: now.subtract(const Duration(days: 3)),
      ),
      ReaderBookModel(
        id: 'psychology_money',
        title: 'Psychology of Money',
        description: 'Timeless lessons on wealth and behavior.',
        authorName: 'Morgan Housel',
        coverUrl: 'assets/covers/money.jpg',
        genre: 'Finance',
        rating: 4.9,
        totalChapters: 22,
        lastReadChapter: 22,
        progressPercent: 100,
        viewsCount: 12870,
        isBookmarked: false,
        lastReadAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<List<ReaderBookModel>> _fetchReaderStudioDataFromFirestore({required String? userId}) async {
    if (userId == null) {
      return <ReaderBookModel>[];
    }

    final booksSnapshot = await _firestore.collection('books').get();
    final progressSnapshot =
        await _firestore.collection('users').doc(userId).collection('readingProgress').get();
    final bookmarkSnapshot =
        await _firestore.collection('users').doc(userId).collection('bookmarks').get();

    final progressMap = {
      for (final doc in progressSnapshot.docs) doc.id: doc.data(),
    };
    final bookmarkIds = bookmarkSnapshot.docs.map((doc) => doc.id).toSet();

    final books = booksSnapshot.docs.map((doc) {
      final progress = progressMap[doc.id];
      return ReaderBookModel(
        id: doc.id,
        title: (doc.data()['title'] ?? '') as String,
        description: (doc.data()['description'] ?? '') as String,
        authorName: (doc.data()['authorName'] ?? '') as String,
        coverUrl: (doc.data()['coverUrl'] ?? '') as String,
        genre: (doc.data()['genre'] ?? '') as String,
        rating: ((doc.data()['rating'] ?? 0) as num).toDouble(),
        totalChapters: (doc.data()['totalChapters'] ?? 0) as int,
        lastReadChapter: (progress?['lastReadChapter'] ?? 0) as int,
        progressPercent: ((progress?['progressPercent'] ?? 0) as num).toDouble(),
        viewsCount: (doc.data()['viewsCount'] ?? 0) as int,
        isBookmarked: bookmarkIds.contains(doc.id),
        lastReadAt: (progress?['lastReadAt'] as Timestamp?)?.toDate(),
      );
    }).toList();

    return books;
  }

  Future<void> _updateBookmarkInFirestore({
    required String userId,
    required ReaderBookModel book,
  }) async {
    final bookmarkRef = _firestore.collection('users').doc(userId).collection('bookmarks').doc(book.id);
    if (book.isBookmarked) {
      await bookmarkRef.set({'savedAt': FieldValue.serverTimestamp()});
    } else {
      await bookmarkRef.delete();
    }
  }

  Future<void> _updateReadingProgressInFirestore({
    required String userId,
    required String bookId,
    required int chapter,
    required double progressPercent,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('readingProgress')
        .doc(bookId)
        .set({
      'lastReadChapter': chapter,
      'progressPercent': progressPercent,
      'lastReadAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
