import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'notification_provider.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final NotificationProvider _notificationProvider;

  CommentProvider({
    FirebaseFirestore? firestore,
    required NotificationProvider notificationProvider,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationProvider = notificationProvider;

  Stream<QuerySnapshot<Map<String, dynamic>>> commentsStream(String bookId) {
    return _firestore
        .collection('books')
        .doc(bookId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addComment({
    required String bookId,
    required String authorId,
    required AppUser user,
    required String commentText,
  }) async {
    if (user.uid.isEmpty) {
      throw Exception('Please login to comment.');
    }

    final trimmed = commentText.trim();
    if (trimmed.isEmpty) {
      throw Exception('Comment cannot be empty.');
    }

    try {
      await _firestore.collection('books').doc(bookId).collection('comments').add({
        'userId': user.uid,
        'userName': user.name,
        'userProfilePic': user.photoUrl ?? user.profileImageUrl ?? '',
        'commentText': trimmed,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (authorId != user.uid) {
        await _notificationProvider.createNotification(
          userId: authorId,
          type: 'comment',
          title: 'New comment',
          body: '${user.name} commented on your book.',
        );
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteComment({
    required String bookId,
    required String commentId,
    required AppUser user,
    required String bookAuthorId,
    required String commentUserId,
  }) async {
    final canDelete = user.uid == commentUserId || user.uid == bookAuthorId;
    if (!canDelete) {
      throw Exception('You do not have permission to delete this comment.');
    }

    try {
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (_) {
      rethrow;
    }
  }
}
