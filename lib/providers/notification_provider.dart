import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  NotificationProvider({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userNotifications(String userId) {
    return _firestore.collection('users').doc(userId).collection('notifications');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream(String userId) {
    return _userNotifications(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<int> unreadCountStream(String userId) {
    return _userNotifications(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
  }) async {
    try {
      await _userNotifications(userId).add({
        'type': type,
        'title': title,
        'body': body,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> markAsRead({required String userId, required String notificationId}) async {
    try {
      await _userNotifications(userId).doc(notificationId).update({'isRead': true});
    } catch (_) {
      rethrow;
    }
  }
}
