import 'package:book_app/features/home/mainicon/quotes_icon/models/quote_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class QuotesService {
  QuotesService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _quotesCollection =>
      _firestore.collection('quotes');

  /// FETCH QUOTES
  Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final snapshot = await _quotesCollection.get();

      final quotes = snapshot.docs.map((doc) {
        return QuoteModel.fromJson(doc.id, doc.data());
      }).toList();

      // SAFE SORT
      quotes.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;

        // ignore: unnecessary_null_comparison
        if (aTime == null && bTime == null) return 0;
        // ignore: unnecessary_null_comparison
        if (aTime == null) return 1;
        // ignore: unnecessary_null_comparison
        if (bTime == null) return -1;

        return bTime.compareTo(aTime);
      });

      return quotes;
    } catch (e) {
      debugPrint("Fetch Quotes Error: $e");
      rethrow;
    }
  }

  /// FETCH CATEGORIES
  Future<List<String>> fetchCategories() async {
    try {
      final snapshot = await _quotesCollection.get();

      final categories = snapshot.docs
          .map((doc) => (doc.data()['category'] as String?)?.trim() ?? '')
          .where((category) => category.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      return categories;
    } catch (e) {
      debugPrint("Fetch Categories Error: $e");
      return [];
    }
  }

  /// ADD QUOTE
  Future<void> addQuote(QuoteModel quote) async {
    try {
      await _quotesCollection.add({
        ...quote.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Add Quote Error: $e");
      rethrow;
    }
  }

  /// LIKE / UNLIKE
  Future<bool> toggleLike({
    required String quoteId,
    required String userId,
  }) async {
    final docRef = _quotesCollection.doc(quoteId);

    try {
      return _firestore.runTransaction<bool>((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Quote not found");
        }

        final data = snapshot.data() ?? {};

        final likedBy = (data['likedBy'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        final hasLiked = likedBy.contains(userId);

        transaction.update(docRef, {
          'likedBy': hasLiked
              ? FieldValue.arrayRemove([userId])
              : FieldValue.arrayUnion([userId]),
          'likes': FieldValue.increment(hasLiked ? -1 : 1),
        });

        return !hasLiked;
      });
    } catch (e) {
      debugPrint("Toggle Like Error: $e");
      rethrow;
    }
  }
}