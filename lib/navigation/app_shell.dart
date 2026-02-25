import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/features/profile/profile_screen.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/navigation/bottom_nav.dart';
import 'package:book_app/models/user_model.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final AppUser? user = authProvider.currentUser;

    final bool isWriterMode =
        user?.currentMode == UserMode.writer ||
        user?.currentMode == UserMode.author;

    final List<Widget> pages = [
      const HomeScreen(),
      const MyLibraryScreen(),
      ProfileScreen(
        isWriterMode: isWriterMode,
        onSwap: () async {
          if (user == null) return;
          final newMode = isWriterMode ? UserMode.reader : UserMode.writer;
          await authProvider.updateUser(user.copyWith(currentMode: newMode));
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
