import 'package:flutter/material.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';
import 'package:book_app/features/profile/profile_screen.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';
import '../navigation/bottom_nav.dart';
import 'package:book_app/models/user_model.dart'; // for AppUser

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

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      WriterDashboard(
        currentUser: widget.currentUser,
        isGuest: widget.isGuest,
      ),
      const MyLibraryScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
