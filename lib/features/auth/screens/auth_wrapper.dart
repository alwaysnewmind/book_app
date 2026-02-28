import 'package:book_app/features/admin/admin_dashboard.dart';
import 'package:book_app/features/auth/screens/genre_selection_screen.dart';
import 'package:book_app/features/auth/screens/login_screen.dart';
import 'package:book_app/features/auth/screens/splash_screen.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!snapshot.exists) {
      await FirebaseAuth.instance.signOut();
      return _AuthDestination.login;
    }

    final data = snapshot.data() ?? <String, dynamic>{};

    if (data['role'] == 'admin') {
      return _AuthDestination.admin;
    }

    if (data['profileCompleted'] == false) {
      return _AuthDestination.roleSelection;
    }

    return _AuthDestination.home;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
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
