import 'package:flutter/material.dart';
import 'package:book_app/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _isGuest = true;

  /// Public Getters
  AppUser? get user => _user;
  bool get isGuest => _isGuest;
  bool get isLoggedIn => _user != null && !_isGuest;

  /// ------------------------------
  /// LOGIN (After Firebase/Auth)
  /// ------------------------------
  void setUser(AppUser user) {
    _user = user;
    _isGuest = false;
    notifyListeners();
  }

  /// ------------------------------
  /// GUEST MODE
  /// ------------------------------
  void continueAsGuest() {
    _user = null;
    _isGuest = true;
    notifyListeners();
  }

  /// ------------------------------
  /// LOGOUT
  /// ------------------------------
  void logout() {
    _user = null;
    _isGuest = true;
    notifyListeners();
  }

  /// ------------------------------
  /// UPDATE USER (Premium / Role etc.)
  /// ------------------------------
  void updateUser(AppUser updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
