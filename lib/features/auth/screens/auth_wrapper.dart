import 'package:book_app/features/admin/admin_dashboard.dart';
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';
import 'package:book_app/features/auth/screens/splash_screen.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/services/auth_service.dart';
import 'package:book_app/services/role_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum _AuthDestination {
  login,
  admin,
  roleSelection,
  home,
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  /// Determine where the user should go based on their Firestore profile
  _AuthDestination _resolveRouteFromProfile(Map<String, dynamic>? profile) {
    if (profile == null) return _AuthDestination.roleSelection;

    final role = profile['role']?.toString();
    final isProfileCompleted = profile['profileCompleted'] == true;

    switch (role) {
      case 'admin':
        return _AuthDestination.admin;
      case 'reader':
      case 'writer':
        return isProfileCompleted ? _AuthDestination.home : _AuthDestination.roleSelection;
      default:
        return _AuthDestination.roleSelection; // Unknown role
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // 🔄 Waiting for Firebase auth state
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // ❌ Auth stream error
        if (authSnapshot.hasError) {
          return const LoginScreen();
        }

        final user = authSnapshot.data;

        // 👤 User not logged in
        if (user == null) return const LoginScreen();

        // 🔄 Fetch user profile from Firestore
        return StreamBuilder<Map<String, dynamic>?>(
          stream: RoleService.instance.userProfileStream(user.uid),
          builder: (context, profileSnapshot) {
            // Waiting for profile fetch
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            // ❌ Firestore error fallback
            if (profileSnapshot.hasError) {
              debugPrint("Firestore error: ${profileSnapshot.error}");
              return const HomeScreen();
            }

            // 🆕 If profile not created yet
            final profileData = profileSnapshot.data;
            if (profileData == null) {
              return const RoleSelectionScreen();
            }

            // Determine destination based on role and profile
            final destination = _resolveRouteFromProfile(profileData);

            switch (destination) {
              case _AuthDestination.admin:
                return const AdminDashboard();
              case _AuthDestination.roleSelection:
                return const RoleSelectionScreen();
              case _AuthDestination.home:
                return const HomeScreen();
              case _AuthDestination.login:
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}