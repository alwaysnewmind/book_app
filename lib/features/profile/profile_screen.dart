import 'package:flutter/material.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/features/home/mainicon/help_support.dart';
import 'package:book_app/features/library/screens/my_library_screen.dart';
import 'package:book_app/services/auth_service.dart';

import 'edit_profile_screen.dart';
import 'subscription_screen.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu.dart';
import 'widgets/profile_stats.dart';

class ProfileScreen extends StatelessWidget {
  final bool isWriterMode;
  final VoidCallback onSwap;

  const ProfileScreen({
    super.key,
    required this.isWriterMode,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final isWriter = isWriterMode;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔝 Top Gradient Header
            Container(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7F53AC),
                    Color(0xFF647DEE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: const ProfileHeader(),
            ),

            const SizedBox(height: 20),

            /// 📜 Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    /// 📊 Stats Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ProfileStats(
                        onTap: (stat) {
                          if (stat == 'books_read' || stat == 'saved') {
                            _pushWithTransition(
                              context,
                              const MyLibraryScreen(),
                            );
                          }

                          if (stat == 'following') {
                            _pushWithTransition(
                              context,
                              const HelpSupportScreen(),
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// ⚙️ Menu Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ProfileMenu(
                        onItemTap: (route) => _handleMenuTap(context, route),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 🔄 Swap Mode Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isWriter ? Colors.orange : Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: onSwap,
                        icon: const Icon(Icons.swap_horiz,
                            color: Colors.white),
                        label: Text(
                          isWriter
                              ? "Switch to Reader"
                              : "Switch to Writer",
                          style:
                              const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// ✏ Floating Edit Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _pushWithTransition(context, const EditProfileScreen());
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  void _handleMenuTap(BuildContext context, String route) {
    switch (route) {
      case 'library':
        _pushWithTransition(context, const MyLibraryScreen());
        break;
      case 'writer_dashboard':
        Navigator.pushNamed(context, AppRoutes.writerDashboard);
        break;
      case 'settings':
        Navigator.pushNamed(context, AppRoutes.settings);
        break;
      case 'help_support':
        _pushWithTransition(context, const HelpSupportScreen());
        break;
      case 'subscription':
        _pushWithTransition(context, const MySubscriptionScreen());
        break;
      case 'logout':
        AuthService.instance.logout();
        break;
    }
  }

  Future<void> _pushWithTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 260),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: page,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
