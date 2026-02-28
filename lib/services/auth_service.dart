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
      throw Exception('User creation failed');
    }

    await _userService.createSignupProfile(
      uid: firebaseUser.uid,
      name: name,
      email: email.trim(),
    );

    return _getOrCreateUser(firebaseUser);
  }

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

    final exists = await _userService.userExists(firebaseUser.uid);
    if (!exists) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'user-profile-not-found',
        message: 'User profile missing. Please contact support.',
      );
    }

    return _getOrCreateUser(firebaseUser);
  }

  Future<({AppUser user, bool isFirstTime})> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'aborted-by-user', message: 'Google sign in cancelled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) {
      throw Exception('Google login failed');
    }

    return _createOrReadSocialUser(firebaseUser);
  }

  Future<({AppUser user, bool isFirstTime})> signInWithMicrosoft() async {
    final OAuthProvider microsoftProvider = OAuthProvider('microsoft.com');
    final userCredential = await _auth.signInWithProvider(microsoftProvider);
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Microsoft login failed');
    }

    return _createOrReadSocialUser(firebaseUser);
  }

  Future<({AppUser user, bool isFirstTime})> _createOrReadSocialUser(User firebaseUser) async {
    final docRef = _usersCollection.doc(firebaseUser.uid);
    final doc = await docRef.get();

    if (doc.exists && doc.data() != null) {
      return (user: AppUser.fromMap(doc.data()!), isFirstTime: false);
    }

    final user = await _createUser(firebaseUser, profileCompleted: false);

    return (user: user, isFirstTime: true);
  }

  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    return _getOrCreateUser(firebaseUser);
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    return doc.data();
  }

  Future<void> completeProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'reader',
      'genres': <String>[],
      'photoUrl': null,
      'profileCompleted': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'currentMode': 'reader',
      'hasCompletedOnboarding': false,
      'selectedGenres': <String>[],
      'favoriteGenres': <String>[],
      'followersCount': 0,
      'followingCount': 0,
      'totalEarnings': 0,
      'availableBalance': 0,
      'premiumActivatedAt': null,
      'premiumExpiry': null,
    }, SetOptions(merge: true));
  }

  Future<void> setUserRole(String uid, String role) async {
    await _usersCollection.doc(uid).set({
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
      'currentMode': role == 'writer' ? 'writer' : 'reader',
    }, SetOptions(merge: true));
  }

  Future<void> setUserGenres(String uid, List<String> genres) async {
    await _usersCollection.doc(uid).set({
      'genres': genres,
      'profileCompleted': true,
      'selectedGenres': genres,
      'hasCompletedOnboarding': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> setUserPhotoUrl(String uid, String photoUrl) async {
    await _usersCollection.doc(uid).set({
      'photoUrl': photoUrl,
      'profileImageUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<bool> isProfileCompleted(String uid) async {
    final data = await getUserDocument(uid);
    return (data?['profileCompleted'] as bool?) ?? false;
  }

  Future<void> logout() async {
    await _auth.signOut();
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
  }

  Future<void> updateUser(AppUser user) async {
    await _usersCollection.doc(user.uid).update(user.toMap());
  }

  Future<AppUser> _getOrCreateUser(User firebaseUser) async {
    final doc = await _usersCollection.doc(firebaseUser.uid).get();

    if (doc.exists && doc.data() != null) {
      return AppUser.fromMap(doc.data()!);
    }

    return _createUser(firebaseUser, profileCompleted: false);
  }

  Future<AppUser> _createUser(
    User firebaseUser, {
    String? name,
    String? city,
    String? phone,
    String? gender,
    DateTime? dob,
    required bool profileCompleted,
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

    final role = 'reader';

    await _usersCollection.doc(firebaseUser.uid).set({
      ...user.toMap(),
      'profileCompleted': profileCompleted,
      'role': role,
      'genres': const <String>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return user;
  }
}
