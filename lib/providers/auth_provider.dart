import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AppUser? _user;
  bool _isGuest = true;

  // Temporary signup storage (before OTP verify)
  String? _pendingName;
  String? _pendingEmail;
  String? _pendingPassword;

  bool _isLoading = false;
  String? _error;

  // ===============================
  // GETTERS
  // ===============================

  AppUser? get user => _user;
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _user != null && !_isGuest;
  bool get isWriterMode => _user?.isWriterMode ?? false;
  bool get canAccessWriter => _user?.canAccessWriter ?? false;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get needsOnboarding =>
      _user != null && !_user!.hasCompletedOnboarding;

  AppUser? get currentUser => null;

  // ===============================
  // INTERNAL HELPERS
  // ===============================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void clearError() {
    _error = null;
  }

  void _clearPendingSignup() {
    _pendingEmail = null;
    _pendingPassword = null;
    _pendingName = null;
  }

  // =====================================================
  // 🔥 SESSION RESTORE (Splash Screen)
  // =====================================================

  Future<void> checkAuthState() async {
    _setLoading(true);

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        final appUser =
            await _authService.fetchUserFromFirestore(firebaseUser.uid);

        _user = appUser;
        _isGuest = false;
      } else {
        _user = null;
        _isGuest = true;
      }
    } catch (e) {
      _setError("Session restore failed");
    }

    _setLoading(false);
  }

  // =====================================================
  // 🎯 DEMO LOGIN - READER (Onboarding visible)
  // =====================================================

  Future<void> demoLoginReader() async {
    _setLoading(true);

    await Future.delayed(const Duration(milliseconds: 800));

    _user = AppUser(
      uid: "demo_reader",
      email: "reader@demo.com",
      name: "Demo Reader",
      role: UserRole.reader,
      currentMode: UserMode.reader,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hasCompletedOnboarding: false, // 🔥 onboarding show
      selectedGenres: [],
    );

    _isGuest = false;
    _setLoading(false);
  }

  // =====================================================
  // 🎯 DEMO LOGIN - WRITER (Onboarding visible)
  // =====================================================

  Future<void> demoLoginWriter() async {
    _setLoading(true);

    await Future.delayed(const Duration(milliseconds: 800));

    _user = AppUser(
      uid: "demo_writer",
      email: "writer@demo.com",
      name: "Demo Writer",
      role: UserRole.writer,
      currentMode: UserMode.writer,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hasCompletedOnboarding: false, // 🔥 onboarding show
      selectedGenres: [],
    );

    _isGuest = false;
    _setLoading(false);
  }

  // =====================================================
  // 📝 REGISTER (TEMP – BEFORE OTP)
  // =====================================================

  Future<void> registerTempUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _pendingName = name;
    _pendingEmail = email;
    _pendingPassword = password;
  }

  // =====================================================
  // 🔐 VERIFY OTP (TEMP OTP: 123456)
  // =====================================================

  Future<bool> verifyOtp(String enteredOtp) async {
    _setLoading(true);
    _setError(null);

    await Future.delayed(const Duration(seconds: 1));

    if (enteredOtp != "123456") {
      _setLoading(false);
      _setError("Invalid OTP");
      return false;
    }

    if (_pendingEmail == null ||
        _pendingPassword == null ||
        _pendingName == null) {
      _setLoading(false);
      _setError("Registration session expired");
      return false;
    }

    try {
      final appUser = await _authService.signUp(
        email: _pendingEmail!,
        password: _pendingPassword!,
        name: _pendingName!,
      );

      _user = appUser.copyWith(
        hasCompletedOnboarding: false,
        selectedGenres: [],
      );

      _isGuest = false;

      _clearPendingSignup();
      _setLoading(false);

      return true;
    } catch (e) {
      _setLoading(false);
      _setError("Signup failed");
      return false;
    }
  }

  // =====================================================
  // 🔑 LOGIN
  // =====================================================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final appUser = await _authService.login(
        email: email,
        password: password,
      );

      _user = appUser;
      _isGuest = false;

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError("Login failed");
      return false;
    }
  }

  // =====================================================
  // 🚪 LOGOUT
  // =====================================================

  Future<void> logout() async {
    await _authService.logout();

    _user = null;
    _isGuest = true;

    notifyListeners();
  }

  // =====================================================
  // 🔥 COMPLETE ONBOARDING
  // =====================================================

  Future<void> completeOnboarding({
    required List<String> genres,
    required String? profileImageUrl,
  }) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(
      selectedGenres: genres,
      profileImageUrl: profileImageUrl,
      hasCompletedOnboarding: true,
    );

    _user = updatedUser;

    // Optional: update Firestore
    await _authService.updateUser(updatedUser);

    notifyListeners();
  }

  // =====================================================
  // 🔁 SWITCH MODE
  // =====================================================

  void switchMode(UserMode mode) {
    if (_user == null) return;

    _user = _user!.copyWith(currentMode: mode);
    notifyListeners();
  }

  // =====================================================
  // 🚀 WRITER TRIAL
  // =====================================================

  void activateWriterTrialIfNeeded() {
    if (_user == null) return;

    if (_user!.writerTrialStart == null) {
      _user = _user!.copyWith(
        writerTrialStart: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // =====================================================
  // 💰 UPGRADE WRITER
  // =====================================================

  void upgradeToWriterPremium() {
    if (_user == null) return;

    _user = _user!.copyWith(isWriterPremium: true);
    notifyListeners();
  }

  // =====================================================
  // 👑 UPGRADE READER
  // =====================================================

  void upgradeToReaderPremium(DateTime expiryDate) {
    if (_user == null) return;

    _user = _user!.copyWith(
      isPremium: true,
      subscriptionExpiry: expiryDate,
    );

    notifyListeners();
  }

  void continueAsGuest() {}
}
