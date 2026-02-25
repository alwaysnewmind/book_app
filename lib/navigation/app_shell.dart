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
  
  const AppShell({super.key});

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

    final AppUser? user = authProvider.currentUser;
    final bool isGuest = authProvider.isGuest;

    final bool isWriterMode =
        user?.currentMode == UserMode.writer ||
        user?.currentMode == UserMode.author;

    final List<Widget> pages = [
      const HomeScreen(),

      WriterDashboard(
        currentUser: user,
        isGuest: isGuest,
        isWriterMode: isWriterMode,
      ),

      const MyLibraryScreen(),

      ProfileScreen(
        isWriterMode: isWriterMode,
        onSwap: () async {
          if (user == null) return;

          final newMode =
              isWriterMode ? UserMode.reader : UserMode.writer;

          final updatedUser =
              user.copyWith(currentMode: newMode);

          await authProvider.updateUser(updatedUser);
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}