// discover_service.dart

import 'package:book_app/features/home/mainicon/discover_icon/models/discover_book_model.dart' show DiscoverBook;
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

class DiscoverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DiscoverBook>> fetchTrendingBooks() async {
    final snapshot = await _firestore
        .collection('books')
        .orderBy('totalReads', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => DiscoverBook.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<DiscoverBook>> fetchNewReleases() async {
    final snapshot = await _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => DiscoverBook.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<DiscoverBook>> fetchRecommendedBooks(
      List<String> genres) async {
    final snapshot = await _firestore
        .collection('books')
        .where('categoryId', whereIn: genres)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => DiscoverBook.fromMap(doc.data(), doc.id))
        .toList();
  }
}