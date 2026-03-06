import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AppUser? _user;
  bool _isLoading = false;
  bool _isGuest = true;
  String? _error;
  String? _selectedUserRole;
  bool _requiresProfileCompletion = false;
  bool _isAdmin = false;

  AppUser? get currentUser => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _user != null && !_isGuest;
  String? get error => _error;
  String? get selectedUserRole => _selectedUserRole;
  bool get needsOnboarding => !(_user?.hasCompletedOnboarding ?? false);
  bool get requiresProfileCompletion => _requiresProfileCompletion;
  bool get isAdmin => _isAdmin;

  Future<void> initialize() async {
    _setLoading(true);

    try {
      final user = await _authService.getCurrentUser();
      _user = user;
      _isGuest = user == null;
      _requiresProfileCompletion = false;
      _isAdmin = false;

      if (user != null) {
        _requiresProfileCompletion =
            !(await _authService.isProfileCompleted(user.uid));
        final doc = await _authService.getUserDocument(user.uid);
        _isAdmin = doc?['role'] == 'admin';
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  Future<void> setUserRole(String role) async {
    _selectedUserRole = role;
    if (_user == null) return;

    try {
      await _authService.setUserRole(uid: _user!.uid,
  role: role,);
      await refreshSession();
      _error = null;
    } catch (e) {
      _error = 'Unable to switch role right now. Please try again.';
    }

    notifyListeners();
  }


  Future<void> refreshSession() async {
    try {
      final freshUser = await _authService.getCurrentUser();
      _user = freshUser;
      _isGuest = freshUser == null;
      if (freshUser != null) {
        final doc = await _authService.getUserDocument(freshUser.uid);
        _isAdmin = doc?['role'] == 'admin';
      }
      _error = null;
    } catch (_) {
      _error = 'Unable to refresh session. Please reopen the app.';
    }
  }

  Future<void> saveGenres(List<String> genres) async {
    if (_user == null) return;
    await _authService.setUserGenres(_user!.uid, genres);
    _user = _user!.copyWith(
      selectedGenres: genres,
      hasCompletedOnboarding: true,
    );
    notifyListeners();
  }

  Future<void> continueAsGuest() async {
    _setLoading(true);

    try {
      final now = DateTime.now();

      _user = AppUser(
        uid: now.millisecondsSinceEpoch.toString(),
        name: 'Guest',
        email: 'guest@mythica.com',
        role: UserRole.reader,
        phone: '',
        city: '',
        currentMode: UserMode.reader,
        createdAt: now,
        updatedAt: now,
        gender: 'unknown',
        selectedGenres: const [],
        favoriteGenres: const [],
        hasCompletedOnboarding: true,
        hasActiveSubscription: false,
      );

      _isGuest = true;
      _requiresProfileCompletion = false;
      _isAdmin = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
    if (!validEmail || name.trim().isEmpty) {
      _error = 'Please enter valid required details.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      _user = user;
      _isGuest = false;
      _requiresProfileCompletion = false;
      _isAdmin = false;
      _error = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final validEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
    if (!validEmail || password.trim().isEmpty) {
      _error = 'Enter valid email and password.';
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );

      _user = user;
      _isGuest = false;
      final doc = await _authService.getUserDocument(user.uid);
      _isAdmin = doc?['role'] == 'admin';
      _requiresProfileCompletion =
          !(await _authService.isProfileCompleted(user.uid));
      _error = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _setLoading(true);

    try {
      final result = await _authService.signInWithGoogle();
      _user = result.user;
      _isGuest = false;
      final doc = await _authService.getUserDocument(result.user.uid);
      _isAdmin = doc?['role'] == 'admin';
      _requiresProfileCompletion =
          result.isFirstTime || !(await _authService.isProfileCompleted(result.user.uid));
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signInWithMicrosoft() async {
    _setLoading(true);

    try {
      final result = await _authService.signInWithMicrosoft();
      _user = result.user;
      _isGuest = false;
      final doc = await _authService.getUserDocument(result.user.uid);
      _isAdmin = doc?['role'] == 'admin';
      _requiresProfileCompletion =
          result.isFirstTime || !(await _authService.isProfileCompleted(result.user.uid));
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> completeProfile({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (_user == null) return false;

    _setLoading(true);

    try {
      await _authService.completeProfile(
        uid: _user!.uid,
        name: name,
        email: email,
        phone: phone,
      );

      final currentFirebaseUser = _authService.currentFirebaseUser;
      if (currentFirebaseUser != null) {
        if (currentFirebaseUser.email != email) {
          await currentFirebaseUser.verifyBeforeUpdateEmail(email);
        }
        await currentFirebaseUser.updatePassword(password);
      }

      _user = _user!.copyWith(name: name, phone: phone);
      _requiresProfileCompletion = false;
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> savePhotoUrl(String photoUrl) async {
    if (_user == null) return;
    await _authService.setUserPhotoUrl(_user!.uid, photoUrl);
    _user = _user!.copyWith(photoUrl: photoUrl, profileImageUrl: photoUrl);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isGuest = true;
    _selectedUserRole = null;
    _requiresProfileCompletion = false;
    _isAdmin = false;
    notifyListeners();
  }

  Future<void> updateUser(AppUser updatedUser) async {
    await _authService.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  String _parseAuthError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Invalid email or password';
        case 'invalid-email':
          return 'Enter a valid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        case 'aborted-by-user':
          return e.message ?? 'Sign in cancelled';
        case 'user-profile-not-found':
          return e.message ?? 'User profile missing';
        default:
          return e.message ?? 'Authentication failed';
      }
    }
    return e.toString();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
