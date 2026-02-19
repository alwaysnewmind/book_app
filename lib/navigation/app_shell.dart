import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/profile/profile_screen.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';

import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/navigation/bottom_nav.dart';
import 'package:book_app/models/user_model.dart';

class AppShell extends StatefulWidget {
  final AppUser? currentUser;
  final bool isGuest;

  const AppShell({
    super.key,
    required this.currentUser,
    required this.isGuest,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final isWriterMode = authProvider.isWriterMode;

    final pages = [
      const HomeScreen(),

      /// ✍ Writer / Reader Dashboard
      WriterDashboard(
        currentUser: widget.currentUser,
        isGuest: widget.isGuest,
        isWriterMode: isWriterMode,
      ),

      const MyLibraryScreen(),

      /// 👤 Profile
      ProfileScreen(
        isWriterMode: isWriterMode,
        onSwap: () {
          authProvider.switchMode(
            isWriterMode
                ? UserMode.reader
                : UserMode.author,
          );
        },
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
