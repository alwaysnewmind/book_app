import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';
import 'auth_state.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =========================
  /// 🔹 GUEST / DEMO LOGIN
  /// =========================
  Future<AuthState> signInAsGuest() async {
    // Fake user for demo mode

    return AuthState.guest();
  }

  /// =========================
  /// 🔹 EMAIL LOGIN (READY)
  /// =========================
  Future<AuthState> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = await _getOrCreateUser(credential.user!);
    return AuthState.loggedIn(user);
  }

  /// =========================
  /// 🔹 SIGN UP
  /// =========================
  Future<AuthState> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = await _createUser(
      credential.user!,
      name: name,
    );

    return AuthState.loggedIn(user);
  }

  /// =========================
  /// 🔹 LOGOUT
  /// =========================
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// =========================
  /// 🔹 GET / CREATE USER
  /// =========================
  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final ref = _firestore.collection('users').doc(firebaseUser.uid);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      return AppUser.fromMap(snapshot.data()!);
    } else {
      return _createUser(firebaseUser);
    }
  }

  Future<AppUser> _createUser(
    User firebaseUser, {
    String? name,
  }) async {
    final user = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: name ?? firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      role: UserRole.reader,
      isPremium: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(user.toMap());

    return user;
  }
}
