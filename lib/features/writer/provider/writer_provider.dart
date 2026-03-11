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

  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  bool get isLoaded => _loaded;
  String? get error => _error;

  int get followersCount => _followersCount;

  List<Book> get writerBooks => List.unmodifiable(_writerBooks);

  /// ---------- STATS ----------

  int get totalBooks => _writerBooks.length;

  double get totalEarnings =>
      _writerBooks.fold(0, (sum, book) => sum + book.totalEarnings);

  int get totalViews =>
      _writerBooks.fold(0, (sum, book) => sum + book.viewsCount);

  double get avgRating {
    if (_writerBooks.isEmpty) return 0;

    return _writerBooks.fold<double>(
          0,
          (sum, book) => sum + book.rating,
        ) /
        _writerBooks.length;
  }

  /// ---------- CONTENT MODERATION ----------

  /// Validate content safety before publishing
  Future<ModerationResult> validateContentSafety({
    required String title,
    required String description,
    required String content,
  }) async {
    _isActionLoading = true;
    notifyListeners();

    try {
      final status = await ContentModerationService.checkContent(
        title,
        description,
        content,
      );

      return status;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// ---------- WRITER ACCESS CONTROL ----------

  /// Check if current writer can edit a specific book
  bool canEditBook({
  required Book book,
  required AppUser? user,
}) {
  /// user must exist
  if (user == null) return false;

  /// only writers or admins can edit
  if (user.role != UserRole.writer && user.role != UserRole.admin) {
    return false;
  }

  /// writer must own the book
  if (book.authorId != user.uid) {
    return false;
  }

  /// prevent editing locked / banned content
  final status = (book as dynamic).status?.toString().toLowerCase();

  const blockedStatuses = [
    'banned',
    'locked',
    'under_review',
  ];

  if (status != null && blockedStatuses.contains(status)) {
    return false;
  }

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

    _followersCount =
        user.followersCount > 0 ? user.followersCount : 128;
  }

  /// ---------- FIRESTORE DATA ----------

  Future<void> _loadFirestoreData(String uid) async {
    final snapshot = await _firestore
        .collection('books')
        .where('authorId', isEqualTo: uid)
        .get();

    _writerBooks = snapshot.docs.map(_bookFromMap).toList();

    final userDoc = await _firestore.collection('users').doc(uid).get();

    _followersCount =
        (userDoc.data()?['followersCount'] as num?)?.toInt() ?? 0;
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
      summary: map['summary']?.toString() ??
          map['description']?.toString() ??
          '',
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