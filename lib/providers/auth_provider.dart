import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AppUser? _user;
  bool _isLoading = false;
  bool _isGuest = true;
  String? _error;
  String? _selectedUserRole;

  // ===============================
  // GETTERS
  // ===============================

  AppUser? get currentUser => _user;
  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _user != null && !_isGuest;
  String? get error => _error;
  String? get selectedUserRole => _selectedUserRole;

  bool get needsOnboarding => false;

  // ===============================
  // INITIALIZE
  // ===============================

  Future<void> initialize() async {
    _setLoading(true);

    try {
      final user = await _authService.getCurrentUser();
      _user = user;
      _isGuest = user == null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  // ===============================
  // SET USER ROLE
  // ===============================

  Future<void> setUserRole(String role) async {
    _selectedUserRole = role;
    notifyListeners();
  }

  // ===============================
  // CONTINUE AS GUEST
  // ===============================

  Future<void> continueAsGuest() async {
    _setLoading(true);

    try {
      final now = DateTime.now();

      _user = AppUser(
        uid: now.millisecondsSinceEpoch.toString(),
        name: "Guest",
        email: "guest@mythica.com",
        role: UserRole.reader,
        phone: "",
        city: "",
        currentMode: UserMode.reader,
        createdAt: now,
        updatedAt: now,
        gender: "unknown",
        selectedGenres: [],
        favoriteGenres: [],
        hasCompletedOnboarding: false,
        hasActiveSubscription: false,
      );

      _isGuest = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  // ===============================
  // SIGN UP
  // ===============================

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      _user = user;
      _isGuest = false;
      _error = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ===============================
  // LOGIN
  // ===============================

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final user = await _authService.login(
        email: email,
        password: password,
      );

      _user = user;
      _isGuest = false;
      _error = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ===============================
  // GOOGLE LOGIN (PLACEHOLDER)
  // ===============================

  Future<bool> signInWithGoogle() async {
    _error = "Google Sign-In not implemented yet";
    notifyListeners();
    return false;
  }

  // ===============================
  // MICROSOFT LOGIN (PLACEHOLDER)
  // ===============================

  Future<bool> signInWithMicrosoft() async {
    _error = "Microsoft Sign-In not implemented yet";
    notifyListeners();
    return false;
  }

  // ===============================
  // LOGOUT
  // ===============================

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isGuest = true;
    _selectedUserRole = null;
    notifyListeners();
  }

  // ===============================
  // UPDATE USER
  // ===============================

  Future<void> updateUser(AppUser updatedUser) async {
    await _authService.updateUser(updatedUser);
    _user = updatedUser;
    notifyListeners();
  }

  // ===============================
  // HELPER
  // ===============================

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}