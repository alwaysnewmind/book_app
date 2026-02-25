import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // =====================================================
  // SIGN UP
  // =====================================================

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    String? city,
    String? phone,
    String? gender,
    DateTime? dob,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception("User creation failed");
    }

    await firebaseUser.sendEmailVerification();

    return _createUser(
      firebaseUser,
      name: name,
      city: city,
      phone: phone,
      gender: gender,
      dob: dob,
    );
  }

  // =====================================================
  // LOGIN
  // =====================================================

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception("Login failed");
    }

    return _getOrCreateUser(firebaseUser);
  }

  // =====================================================
  // CURRENT USER
  // =====================================================

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return _getOrCreateUser(firebaseUser);
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
    await _auth.signOut();
  }

  // =====================================================
  // UPDATE USER
  // =====================================================

  Future<void> updateUser(AppUser user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  // =====================================================
  // GET OR CREATE USER
  // =====================================================

  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final doc = await _usersCollection.doc(firebaseUser.uid).get();

    if (doc.exists && doc.data() != null) {
      return AppUser.fromMap(doc.data()!);
    }

    return _createUser(firebaseUser);
  }

  // =====================================================
  // CREATE USER
  // =====================================================

  Future<AppUser> _createUser(
    User firebaseUser, {
    String? name,
    String? city,
    String? phone,
    String? gender,
    DateTime? dob,
  }) async {
    final now = DateTime.now();

    final user = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: name ?? firebaseUser.displayName ?? 'User',
      phone: phone ?? firebaseUser.phoneNumber ?? '',
      city: city ?? '',
      gender: gender ?? '',
      dob: dob,
      photoUrl: firebaseUser.photoURL,
      profileImageUrl: null,
      role: UserRole.reader,
      hasActiveSubscription: false, 
      currentMode: UserMode.reader,
      isPremium: false,
      subscriptionExpiry: null,
      writerTrialStart: null,
      isWriterPremium: false,
      hasCompletedOnboarding: false,
      selectedGenres: [],
      favoriteGenres: [],
      createdAt: now,
      updatedAt: now,
    );

    await _usersCollection.doc(firebaseUser.uid).set(user.toMap());

    return user;
  }
}