import 'package:book_app/config/app_config.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/models/writer_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WriterProvider extends ChangeNotifier {
  WriterProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  bool _loaded = false;
  String? _error;
  String? _writerId;
  int _followersCount = 0;
  List<Book> _writerBooks = const [];

  bool get isLoading => _isLoading;
  bool get isLoaded => _loaded;
  String? get error => _error;
  int get followersCount => _followersCount;
  List<Book> get writerBooks => List.unmodifiable(_writerBooks);

  int get totalBooks => _writerBooks.length;
  double get totalEarnings =>
      // ignore: avoid_types_as_parameter_names
      _writerBooks.fold<double>(0, (sum, book) => sum + book.totalEarnings);
  int get totalViews =>
      // ignore: avoid_types_as_parameter_names
      _writerBooks.fold<int>(0, (sum, book) => sum + book.viewsCount);
  double get avgRating {
    if (_writerBooks.isEmpty) return 0;
    final total = _writerBooks.fold<double>(0, (sum, book) => sum + book.rating);
    return total / _writerBooks.length;
  }

  Future<void> loadWriterStudio({
    required AppUser? user,
    required bool isGuest,
    bool forceRefresh = false,
  }) async {
    if (user == null || isGuest) {
      _error = 'Sign in with a writer account to access this feature.';
      _writerBooks = const [];
      _loaded = true;
      notifyListeners();
      return;
    }

    final role = user.role;
    if (role != UserRole.writer && role != UserRole.admin) {
      _error = 'Switch to Writer account from Profile to access this feature';
      _writerBooks = const [];
      _loaded = true;
      notifyListeners();
      return;
    }

    if (!forceRefresh && _loaded && _writerId == user.uid) {
      return;
    }

    _isLoading = true;
    _error = null;
    _writerId = user.uid;
    notifyListeners();

    try {
      if (isDummyMode) {
        await _loadDummyData(user);
      } else {
        await _loadFirestoreData(user.uid);
      }
      _loaded = true;
    } catch (_) {
      _error = 'Unable to load writer studio right now. Please try again.';
      _writerBooks = const [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool canEditBook({required Book book, required AppUser? user}) {
    if (user == null) return false;
    if (user.role == UserRole.admin) return true;
    return book.authorId == user.uid;
  }

  Future<void> _loadDummyData(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final userBooks = dummyBooks.where((book) => book.authorId == user.uid).toList();
    _writerBooks = userBooks.isNotEmpty
        ? userBooks
        : dummyBooks.where((book) => book.authorId == 'writer_1').toList();
    _followersCount = user.followersCount > 0 ? user.followersCount : 128;
  }

  Future<void> _loadFirestoreData(String uid) async {
    final booksSnapshot = await _firestore
        .collection('books')
        .where('authorId', isEqualTo: uid)
        .get();

    _writerBooks = booksSnapshot.docs.map(_bookFromMap).toList();

    final profileSnapshot = await _firestore.collection('users').doc(uid).get();
    _followersCount = (profileSnapshot.data()?['followersCount'] as num?)?.toInt() ?? 0;
  }

  Book _bookFromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? <String, dynamic>{};
    return Book(
      id: doc.id,
      title: map['title']?.toString() ?? '',
      author: map['authorName']?.toString() ?? 'Unknown',
      authorName: map['authorName']?.toString() ?? 'Unknown',
      authorId: map['authorId']?.toString() ?? '',
      coverImage: map['coverImage']?.toString() ?? 'assets/books/Book1.png',
      summary: map['summary']?.toString() ?? map['description']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      isPaid: map['isPaid'] == true,
      isPremium: map['isPaid'] == true,
      price: (map['price'] as num?)?.toDouble() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0,
      genre: map['genre']?.toString() ?? 'General',
      viewsCount: (map['viewsCount'] as num?)?.toInt() ?? 0,
    );
  }
}
