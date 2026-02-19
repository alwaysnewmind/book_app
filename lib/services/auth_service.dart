import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =====================================================
  // SIGN UP
  // =====================================================

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;
    return await _createUser(firebaseUser, name: name);
  }

  // =====================================================
  // LOGIN
  // =====================================================

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;
    return await _getOrCreateUser(firebaseUser);
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // =====================================================
  // FETCH USER (SESSION RESTORE)
  // =====================================================

  Future<AppUser> fetchUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("User not found");
    }

    return AppUser.fromMap(doc.data()!);
  }

  // =====================================================
  // UPDATE USER (🔥 REQUIRED FIX)
  // =====================================================

  Future<void> updateUser(AppUser user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update(
      user.toMap()
        ..addAll({
          "updatedAt": Timestamp.now(),
        }),
    );
  }

  // =====================================================
  // GET OR CREATE USER
  // =====================================================

  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final ref = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.data() != null) {
      return AppUser.fromMap(snapshot.data()!);
    } else {
      return await _createUser(firebaseUser);
    }
  }

  // =====================================================
  // CREATE NEW USER
  // =====================================================

  Future<AppUser> _createUser(
    User firebaseUser, {
    String? name,
  }) async {
    final now = DateTime.now();

    final user = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: name ?? firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      role: UserRole.reader,
      currentMode: UserMode.reader, 
      isPremium: false,
      isWriterPremium: false,
      hasCompletedOnboarding: false,
      selectedGenres: [],
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(user.toMap());

    return user;
  }
}
