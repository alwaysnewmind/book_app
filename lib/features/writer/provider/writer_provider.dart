import 'package:book_app/config/app_config.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/models/writer_book_model.dart';
import 'package:book_app/features/writer/widgets/content_moderation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WriterProvider extends ChangeNotifier {
  WriterProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  bool _isLoading = false;
  bool _isActionLoading = false;
  bool _loaded = false;

  String? _error;
  String? _writerId;

  int _followersCount = 0;

  List<Book> _writerBooks = const [];

  /// Async action tracking per book (e.g., publish, delete)
  final Map<String, bool> _bookActionLoading = {};

  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  bool get isLoaded => _loaded;
  String? get error => _error;

  int get followersCount => _followersCount;
  List<Book> get writerBooks => List.unmodifiable(_writerBooks);

  bool isBookProcessing(String bookId) => _bookActionLoading[bookId] ?? false;

  /// ---------- STATS ----------
  int get totalBooks => _writerBooks.length;
  double get totalEarnings =>
      _writerBooks.fold(0, (sum, book) => sum + book.totalEarnings);
  int get totalViews =>
      _writerBooks.fold(0, (sum, book) => sum + book.viewsCount);
  double get avgRating {
    if (_writerBooks.isEmpty) return 0;
    return _writerBooks.fold<double>(0, (sum, book) => sum + book.rating) /
        _writerBooks.length;
  }

  /// ---------- CONTENT MODERATION ----------
  Future<ModerationResult> validateContentSafety({
    required String title,
    required String description,
    required String content,
  }) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      return await ContentModerationService.checkContent(
        title,
        description,
        content,
      );
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// ---------- WRITER ACCESS CONTROL ----------
  bool canEditBook({
    required Book book,
    required AppUser? user,
  }) {
    if (user == null) return false;
    if (user.role != UserRole.writer && user.role != UserRole.admin) return false;
    if (book.authorId != user.uid) return false;

    final status = (book as dynamic).status?.toString().toLowerCase();
    const blockedStatuses = ['banned', 'locked', 'under_review'];
    if (status != null && blockedStatuses.contains(status)) return false;

    return true;
  }

  /// ---------- LOAD WRITER STUDIO ----------
  Future<void> loadWriterStudio({
    required AppUser? user,
    required bool isGuest,
    bool forceRefresh = false,
  }) async {
    if (user == null || isGuest) {
      _setError('Sign in with a writer account to access this feature.');
      return;
    }
    if (user.role != UserRole.writer && user.role != UserRole.admin) {
      _setError('Switch to Writer account from Profile to access this feature.');
      return;
    }
    if (!forceRefresh && _loaded && _writerId == user.uid) return;

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
    } catch (e) {
      _setError('Unable to load writer studio. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _error = message;
    _writerBooks = const [];
    _loaded = true;
    _isLoading = false;
    notifyListeners();
  }

  /// ---------- DUMMY DATA ----------
  Future<void> _loadDummyData(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _writerBooks =
        dummyBooks.where((book) => book.authorId == user.uid).toList();
    _followersCount = user.followersCount > 0 ? user.followersCount : 128;
  }

  /// ---------- FIRESTORE DATA ----------
  Future<void> _loadFirestoreData(String uid) async {
    final snapshot =
        await _firestore.collection('books').where('authorId', isEqualTo: uid).get();
    _writerBooks = snapshot.docs.map(_bookFromMap).toList();

    final userDoc = await _firestore.collection('users').doc(uid).get();
    _followersCount = (userDoc.data()?['followersCount'] as num?)?.toInt() ?? 0;
  }

  /// ---------- BOOK PARSER ----------
  Book _bookFromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data() ?? {};
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

  /// ---------- CRUD OPERATIONS ----------
  Future<void> createBook(Book book) async {
    _isActionLoading = true;
    notifyListeners();
    try {
      final docRef = await _firestore.collection('books').add({
        'title': book.title,
        'authorName': book.authorName,
        'authorId': book.authorId,
        'coverImage': book.coverImage,
        'summary': book.summary,
        'rating': book.rating,
        'reviewCount': book.reviewCount,
        'isPaid': book.isPaid,
        'price': book.price,
        'totalEarnings': book.totalEarnings,
        'genre': book.genre,
        'viewsCount': book.viewsCount,
        'status': 'draft',
      });
      _writerBooks.add(book.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      _setError('Failed to create book.');
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBook(String bookId, Map<String, dynamic> newData) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore.collection('books').doc(bookId).update(newData);
      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] = _writerBooks[index].copyWithMap(newData);
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to update book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<void> deleteBook(String bookId) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore.collection('books').doc(bookId).delete();
      _writerBooks.removeWhere((b) => b.id == bookId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  Future<void> publishBook(String bookId) async {
    _bookActionLoading[bookId] = true;
    notifyListeners();
    try {
      await _firestore
          .collection('books')
          .doc(bookId)
          .update({'status': 'published'});
      final index = _writerBooks.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        _writerBooks[index] =
            _writerBooks[index].copyWithMap({'status': 'published'});
      }
      notifyListeners();
    } catch (e) {
      _setError('Failed to publish book.');
    } finally {
      _bookActionLoading[bookId] = false;
      notifyListeners();
    }
  }

  /// ---------- ANALYTICS ----------
  Map<String, dynamic> bookAnalytics(String bookId) {
    final book = _writerBooks.firstWhere((b) => b.id == bookId, orElse: () => Book.empty());
    return {
      'views': book.viewsCount,
      'earnings': book.totalEarnings,
      'rating': book.rating,
    };
  }
}