import 'package:book_app/features/quotes/models/quote_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuotesService {
  QuotesService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _quotesCollection =>
      _firestore.collection('quotes');

  Future<List<QuoteModel>> fetchQuotes() async {
    final snapshot = await _quotesCollection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => QuoteModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final snapshot = await _quotesCollection.get();

    final categories = snapshot.docs
        .map((doc) => (doc.data()['category'] as String?)?.trim() ?? '')
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return categories;
  }

  Future<void> addQuote(QuoteModel quote) async {
    await _quotesCollection.add(<String, dynamic>{
      ...quote.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> toggleLike({
    required String quoteId,
    required String userId,
  }) async {
    final docRef = _quotesCollection.doc(quoteId);
    return _firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data() ?? <String, dynamic>{};
      final likedBy = (data['likedBy'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          <String>[];
      final hasLiked = likedBy.contains(userId);

      transaction.update(docRef, <String, dynamic>{
        'likedBy': hasLiked
            ? FieldValue.arrayRemove(<String>[userId])
            : FieldValue.arrayUnion(<String>[userId]),
        'likes': FieldValue.increment(hasLiked ? -1 : 1),
      });

      return !hasLiked;
    });
  }
}
