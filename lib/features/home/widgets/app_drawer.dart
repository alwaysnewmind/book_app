import 'dart:ui';
import 'package:book_app/features/profile/profile_screen.dart' show ProfileScreen;
import 'package:book_app/features/subscription/reader_subscription_screen.dart' show ReaderSubscriptionScreen;
import 'package:flutter/material.dart';
import 'package:book_app/features/profile/edit_profile_screen.dart';
import 'package:book_app/features/settings/screens/settings_screen.dart';
import '../../library/screens/my_library_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // 🎨 Luxury Color System
  static const Color bgTop = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgBottom = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldDark = Color(0xFFE6B93E);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderInactive = Color(0xFF3A2D5C);

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        final slide = Tween<Offset>(
          begin: const Offset(0.1, 0),
          end: Offset.zero,
        ).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [bgTop, bgMid, bgBottom],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withOpacity(0.30),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: bgTop.withOpacity(0.95),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    /// PROFILE HEADER
                    _buildProfileHeader(),

                    const SizedBox(height: 28),

                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        children: [
                          _menuItem(
                            context,
                            icon: Icons.person_outline,
                            title: "My Account",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                _animatedRoute(
                                  ProfileScreen(
                                    isWriterMode: false,
                                    onSwap: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            context,
                            icon: Icons.edit_outlined,
                            title: "Edit Profile",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                _animatedRoute(const EditProfileScreen()),
                              );
                            },
                          ),
                          _menuItem(
                            context,
                            icon: Icons.subscriptions_outlined,
                            title: "My Subscription",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                _animatedRoute(const ReaderSubscriptionScreen()),
                              );
                            },
                          ),
                          _menuItem(
                            context,
                            icon: Icons.library_books_outlined,
                            title: "My Library",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                _animatedRoute(const MyLibraryScreen()),
                              );
                            },
                          ),
                          _menuItem(
                            context,
                            icon: Icons.settings_outlined,
                            title: "Settings",
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                _animatedRoute(const SettingsScreen()),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          _menuItem(
                            context,
                            icon: Icons.logout,
                            title: "Logout",
                            isLogout: true,
                            onTap: () {
                              Navigator.pop(context);
                              _showLogoutDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          height: 92,
          width: 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cardFill,
            border: Border.all(color: borderInactive),
            boxShadow: [
              BoxShadow(
                color: goldGlow.withOpacity(0.30),
                blurRadius: 18,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "RP",
              style: TextStyle(
                fontSize: 30,
                color: gold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          "Riddhi Shah",
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "0018223778960",
          style: TextStyle(
            color: textMuted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: cardFill,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderInactive),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? goldDark : gold,
              ),
              const SizedBox(width: 18),
              Text(
                title,
                style: TextStyle(
                  color: isLogout ? goldDark : textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(color: textPrimary),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add Firebase logout logic
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: gold),
            ),
          ),
        ],
      ),
    );
  }
}