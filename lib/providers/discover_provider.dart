import 'package:book_app/config/app_config.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/models/writer_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiscoverProvider extends ChangeNotifier {
  DiscoverProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  String? _error;
  String _selectedGenre = 'All';
  String _searchQuery = '';

  List<Book> _allBooks = [];
  List<Book> _visibleBooks = [];
  List<Book> _trendingBooks = [];
  List<Book> _popularBooks = [];
  List<Book> _newArrivalsBooks = [];
  List<Book> _topRatedBooks = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedGenre => _selectedGenre;
  String get searchQuery => _searchQuery;

  List<Book> get allBooks => List.unmodifiable(_allBooks);
  List<Book> get visibleBooks => List.unmodifiable(_visibleBooks);
  List<Book> get trendingBooks => List.unmodifiable(_trendingBooks);
  List<Book> get popularBooks => List.unmodifiable(_popularBooks);
  List<Book> get newArrivalsBooks => List.unmodifiable(_newArrivalsBooks);
  List<Book> get topRatedBooks => List.unmodifiable(_topRatedBooks);

  List<String> get genres {
    final set = <String>{'All'};
    for (final book in _allBooks) {
      if (book.genre.trim().isNotEmpty) {
        set.add(book.genre);
      }
    }
    return set.toList();
  }

  Future<void> loadDiscoverData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allBooks = isDummyMode ? await _loadDummyBooks() : await _loadFirestoreBooks();
      _applyFilters();
      if (isDummyMode) {
        _trendingBooks = getTrendingBooks();
        _popularBooks = getPopularBooks();
        _newArrivalsBooks = getNewArrivals();
        _topRatedBooks = getTopRatedBooks();
      } else {
        _trendingBooks = await fetchTrendingBooksFromFirestore();
        _popularBooks = await fetchPopularBooksFromFirestore();
        _newArrivalsBooks = await fetchNewArrivalsFromFirestore();
        _topRatedBooks = await fetchTopRatedBooksFromFirestore();
      }
    } catch (e) {
      _error = 'Something went wrong while loading Discover data.';
      _allBooks = [];
      _visibleBooks = [];
      _trendingBooks = [];
      _popularBooks = [];
      _newArrivalsBooks = [];
      _topRatedBooks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Book>> _loadDummyBooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return dummyBooks;
  }

  Future<List<Book>> _loadFirestoreBooks() async {
    final snapshot = await _firestore.collection('books').get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  Book _mapFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    final createdAtRaw = map['createdAt'];

    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      coverImage: map['coverImage']?.toString() ?? 'assets/books/Book1.png',
      summary: map['description']?.toString() ?? '',
      genre: map['genre']?.toString() ?? 'General',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      createdAt: createdAtRaw is Timestamp
          ? createdAtRaw.toDate()
          : createdAtRaw is DateTime
              ? createdAtRaw
              : DateTime.now(),
    );
  }

  List<Book> getTrendingBooks() {
    final sorted = [..._visibleBooks]..sort((a, b) => b.viewsCount.compareTo(a.viewsCount));
    return sorted.take(10).toList();
  }

  List<Book> getPopularBooks() {
    final sorted = [..._visibleBooks]..sort((a, b) => b.totalEarnings.compareTo(a.totalEarnings));
    return sorted.take(10).toList();
  }

  List<Book> getNewArrivals() {
    final sorted = [..._visibleBooks]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  List<Book> getTopRatedBooks() {
    final rated = _visibleBooks.where((book) => book.rating >= 4).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return rated.take(10).toList();
  }

  Future<List<Book>> fetchTrendingBooksFromFirestore() async {
    final snapshot = await _firestore.collection('books').orderBy('viewsCount', descending: true).limit(10).get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  Future<List<Book>> fetchPopularBooksFromFirestore() async {
    final snapshot = await _firestore.collection('books').orderBy('totalEarnings', descending: true).limit(10).get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  Future<List<Book>> fetchNewArrivalsFromFirestore() async {
    final snapshot = await _firestore.collection('books').orderBy('createdAt', descending: true).limit(10).get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  Future<List<Book>> fetchTopRatedBooksFromFirestore() async {
    final snapshot = await _firestore
        .collection('books')
        .where('rating', isGreaterThanOrEqualTo: 4)
        .orderBy('rating', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map(_mapFromFirestore).toList();
  }

  void filterByGenre(String genre) {
    _selectedGenre = genre;
    _applyFilters();
    _trendingBooks = getTrendingBooks();
    _popularBooks = getPopularBooks();
    _newArrivalsBooks = getNewArrivals();
    _topRatedBooks = getTopRatedBooks();
    notifyListeners();
  }

  void searchBooks(String query) {
    _searchQuery = query;
    _applyFilters();
    _trendingBooks = getTrendingBooks();
    _popularBooks = getPopularBooks();
    _newArrivalsBooks = getNewArrivals();
    _topRatedBooks = getTopRatedBooks();
    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadDiscoverData();
  }

  void _applyFilters() {
    var books = [..._allBooks];

    if (_selectedGenre != 'All') {
      books = books.where((book) => book.genre.toLowerCase() == _selectedGenre.toLowerCase()).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      books = books
          .where((book) =>
              book.title.toLowerCase().contains(query) ||
              book.authorName.toLowerCase().contains(query))
          .toList();
    }

    _visibleBooks = books;
  }
}
