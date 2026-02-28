import 'package:cloud_firestore/cloud_firestore.dart';

class RoleService {
  RoleService._();
  static final RoleService instance = RoleService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> userRef(String uid) =>
      _firestore.collection('users').doc(uid);

  Stream<Map<String, dynamic>?> userProfileStream(String uid) {
    return userRef(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    final snapshot = await userRef(uid).get();
    return snapshot.data();
  }

  Future<String?> fetchRole(String uid) async {
    final profile = await fetchUserProfile(uid);
    return profile?['role']?.toString();
  }

  bool isWriterOrAdmin(String? role) => role == 'writer' || role == 'admin';

  bool isReader(String? role) => role == 'reader';

  Future<void> switchRole({
    required String uid,
    required String targetRole,
  }) async {
    if (targetRole != 'reader' && targetRole != 'writer') {
      throw ArgumentError('Unsupported role switch target: $targetRole');
    }

    await userRef(uid).update({
      'role': targetRole,
      'currentMode': targetRole,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
