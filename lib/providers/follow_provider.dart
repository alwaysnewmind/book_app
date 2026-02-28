import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'notification_provider.dart';

class FollowProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final NotificationProvider _notificationProvider;

  FollowProvider({
    FirebaseFirestore? firestore,
    required NotificationProvider notificationProvider,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _notificationProvider = notificationProvider;

  Stream<bool> isFollowingStream({
    required String readerId,
    required String writerId,
  }) {
    return _firestore
        .collection('users')
        .doc(writerId)
        .collection('followers')
        .doc(readerId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<int> followersCountStream(String writerId) {
    return _firestore
        .collection('users')
        .doc(writerId)
        .snapshots()
        .map((event) => (event.data()?['followersCount'] as num?)?.toInt() ?? 0);
  }

  Stream<int> followingCountStream(String readerId) {
    return _firestore
        .collection('users')
        .doc(readerId)
        .snapshots()
        .map((event) => (event.data()?['followingCount'] as num?)?.toInt() ?? 0);
  }

  Future<void> toggleFollow({
    required AppUser currentUser,
    required String writerId,
    required String writerName,
  }) async {
    if (currentUser.uid == writerId) {
      throw Exception('Writers cannot follow themselves.');
    }

    if (currentUser.role != UserRole.reader) {
      throw Exception('Only readers can follow writers.');
    }

    final writerFollowerRef = _firestore
        .collection('users')
        .doc(writerId)
        .collection('followers')
        .doc(currentUser.uid);

    final readerFollowingRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('following')
        .doc(writerId);

    final writerRef = _firestore.collection('users').doc(writerId);
    final readerRef = _firestore.collection('users').doc(currentUser.uid);

    await _firestore.runTransaction((transaction) async {
      final existing = await transaction.get(writerFollowerRef);
      if (existing.exists) {
        transaction.delete(writerFollowerRef);
        transaction.delete(readerFollowingRef);
        transaction.update(writerRef, {'followersCount': FieldValue.increment(-1)});
        transaction.update(readerRef, {'followingCount': FieldValue.increment(-1)});
      } else {
        transaction.set(writerFollowerRef, {
          'followerId': currentUser.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.set(readerFollowingRef, {
          'writerId': writerId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.update(writerRef, {'followersCount': FieldValue.increment(1)});
        transaction.update(readerRef, {'followingCount': FieldValue.increment(1)});
      }
    });

    final latest = await writerFollowerRef.get();
    if (latest.exists) {
      await _notificationProvider.createNotification(
        userId: writerId,
        type: 'follow',
        title: 'New follower',
        body: '${currentUser.name} started following you.',
      );
    }
  }
}
