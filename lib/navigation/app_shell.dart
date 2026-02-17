import 'package:flutter/material.dart';
import 'package:book_app/features/home/home_screen.dart';
import 'package:book_app/features/writer/Screens/writer_dashboard.dart';
import 'package:book_app/features/profile/profile_screen.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';
import '../navigation/bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    WriterDashboard(),
    MyLibraryScreen(),
    ProfileScreen(),
  ];

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
