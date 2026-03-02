import 'package:book_app/features/reviews/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  ReviewService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _reviewsRef(String bookId) {
    return _firestore.collection('books').doc(bookId).collection('reviews');
  }

  Future<List<ReviewModel>> fetchReviews(String bookId) async {
    try {
      final snapshot = await _reviewsRef(bookId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch reviews: ${e.message ?? e.code}');
    } catch (_) {
      throw Exception('Failed to fetch reviews. Please try again.');
    }
  }

  Future<void> addReview(String bookId, ReviewModel review) async {
    try {
      await _reviewsRef(bookId).add({
        ...review.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to submit review: ${e.message ?? e.code}');
    } catch (_) {
      throw Exception('Failed to submit review. Please try again.');
    }
  }

  Future<void> toggleLike(String bookId, String reviewId, String userId) async {
    final reviewRef = _reviewsRef(bookId).doc(reviewId);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(reviewRef);
        if (!snapshot.exists) {
          throw Exception('Review not found.');
        }

        final data = snapshot.data() ?? <String, dynamic>{};
        final likedByRaw = (data['likedBy'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => e.toString())
            .toList();
        final currentLikes = (data['likes'] as num?)?.toInt() ?? 0;
        final alreadyLiked = likedByRaw.contains(userId);

        final updateData = alreadyLiked
            ? {
                'likedBy': FieldValue.arrayRemove([userId]),
                'likes': FieldValue.increment(currentLikes > 0 ? -1 : 0),
              }
            : {
                'likedBy': FieldValue.arrayUnion([userId]),
                'likes': FieldValue.increment(1),
              };

        transaction.update(reviewRef, updateData);
      });
    } on FirebaseException catch (e) {
      throw Exception('Failed to update like: ${e.message ?? e.code}');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to update like. Please try again.');
    }
  }
}
