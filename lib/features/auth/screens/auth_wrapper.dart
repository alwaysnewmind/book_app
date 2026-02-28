import 'package:book_app/features/admin/admin_dashboard.dart';
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';
import 'package:book_app/features/auth/screens/splash_screen.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/services/auth_service.dart';
import 'package:book_app/services/user_service.dart';
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

  Future<_AuthDestination> _resolveAuthenticatedRoute(String uid) async {
    final userService = UserService.instance;
    final profile = await userService.fetchUserProfile(uid);

    if (profile == null) {
      await AuthService.instance.logout();
      return _AuthDestination.login;
    }

    if (userService.isAdmin(profile)) {
      return _AuthDestination.admin;
    }

    final role = userService.roleOf(profile);
    if (role != 'reader' && role != 'writer') {
      return _AuthDestination.roleSelection;
    }

    if (!userService.isProfileCompleted(profile)) {
      return _AuthDestination.roleSelection;
    }

    return _AuthDestination.home;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder<_AuthDestination>(
          future: _resolveAuthenticatedRoute(user.uid),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (profileSnapshot.hasError) {
              return const LoginScreen();
            }

            switch (profileSnapshot.data) {
              case _AuthDestination.admin:
                return const AdminDashboard();
              case _AuthDestination.roleSelection:
                return const RoleSelectionScreen();
              case _AuthDestination.home:
                return const HomeScreen();
              case _AuthDestination.login:
              default:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
