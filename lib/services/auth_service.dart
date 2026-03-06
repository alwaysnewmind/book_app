import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:book_app/services/user_service.dart';
import '../../models/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  User? get currentFirebaseUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// ==============================
  /// EMAIL SIGN UP
  /// ==============================
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception('User creation failed');
    }

    await _userService.createSignupProfile(
      uid: firebaseUser.uid,
      name: name,
      email: email.trim(),
    );

    return _getOrCreateUser(firebaseUser);
  }

  /// ==============================
  /// EMAIL LOGIN
  /// ==============================
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
      throw Exception('Login failed');
    }

    return _getOrCreateUser(firebaseUser);
  }

  /// ==============================
  /// GOOGLE LOGIN
  /// ==============================
  Future<({AppUser user, bool isFirstTime})> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'aborted-by-user');
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }

    final doc = await _usersCollection.doc(firebaseUser.uid).get();
    final isFirstTime = !doc.exists;

    final appUser = await _getOrCreateUser(firebaseUser);

    return (user: appUser, isFirstTime: isFirstTime);
  }

  /// ==============================
  /// MICROSOFT LOGIN
  /// ==============================
  Future<({AppUser user, bool isFirstTime})> signInWithMicrosoft() async {
    final microsoftProvider = OAuthProvider("microsoft.com");

    final userCredential =
        await _auth.signInWithProvider(microsoftProvider);

    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw FirebaseAuthException(code: 'invalid-credential');
    }

    final doc = await _usersCollection.doc(firebaseUser.uid).get();
    final isFirstTime = !doc.exists;

    final appUser = await _getOrCreateUser(firebaseUser);

    return (user: appUser, isFirstTime: isFirstTime);
  }

  /// ==============================
  /// CURRENT USER SAFE
  /// ==============================
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      return await _getOrCreateUser(firebaseUser)
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  /// ==============================
  /// GET USER DOC
  /// ==============================
  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid)
          .get()
          .timeout(const Duration(seconds: 8));
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  /// ==============================
  /// PROFILE COMPLETION CHECK
  /// ==============================
  Future<bool> isProfileCompleted(String uid) async {
    final data = await getUserDocument(uid);
    return (data?['profileCompleted'] as bool?) ?? false;
  }

  /// ==============================
  /// SET ROLE
  /// ==============================
  Future<void> setUserRole({
    required String uid,
    required String role,
  }) async {
    await _usersCollection.doc(uid).set({
      'role': role,
      'currentMode': role,
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ==============================
  /// COMPLETE PROFILE
  /// ==============================
  Future<void> completeProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ==============================
  /// SET PHOTO
  /// ==============================
  Future<void> setUserPhotoUrl(String uid, String photoUrl) async {
    await _usersCollection.doc(uid).update({
      'photoUrl': photoUrl,
      'profileImageUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==============================
  /// SET GENRES
  /// ==============================
  Future<void> setUserGenres(String uid, List<String> genres) async {
    await _usersCollection.doc(uid).update({
      'selectedGenres': genres,
      'favoriteGenres': genres,
      'hasCompletedOnboarding': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// ==============================
  /// LOGOUT
  /// ==============================
  Future<void> logout() async {
    await _auth.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  /// ==============================
  /// UPDATE USER
  /// ==============================
  Future<void> updateUser(AppUser user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  /// ==============================
  /// INTERNAL: GET OR CREATE
  /// ==============================
  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    try {
      final doc = await _usersCollection.doc(firebaseUser.uid).get();

      if (doc.exists && doc.data() != null) {
        return AppUser.fromMap(doc.data()!);
      }
    } catch (_) {}

    return _createUser(firebaseUser);
  }

  /// ==============================
  /// INTERNAL: CREATE USER
  /// ==============================
  Future<AppUser> _createUser(User firebaseUser) async {
    final now = DateTime.now();

    final user = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? 'User',
      phone: firebaseUser.phoneNumber ?? '',
      city: '',
      gender: '',
      dob: null,
      photoUrl: firebaseUser.photoURL,
      profileImageUrl: firebaseUser.photoURL,
      role: UserRole.reader,
      hasActiveSubscription: false,
      currentMode: UserMode.reader,
      isPremium: false,
      subscriptionExpiry: null,
      writerTrialStart: null,
      isWriterPremium: false,
      premiumActivatedAt: null,
      premiumExpiry: null,
      followersCount: 0,
      followingCount: 0,
      totalEarnings: 0,
      availableBalance: 0,
      hasCompletedOnboarding: false,
      selectedGenres: const [],
      favoriteGenres: const [],
      createdAt: now,
      updatedAt: now,
    );

    await _usersCollection.doc(firebaseUser.uid).set({
      ...user.toMap(),
      'profileCompleted': false,
      'role': 'reader',
      'currentMode': 'reader',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return user;
  }
}