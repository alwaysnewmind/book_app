import 'dart:ui';
import 'package:book_app/features/profile/edit_profile_screen.dart' show EditProfileScreen;
import 'package:flutter/material.dart';
import 'package:book_app/features/settings/screens/settings_screen.dart';
import '../../library/screens/my_library_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        final slide = Tween<Offset>(
          begin: const Offset(0.15, 0),
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7B2FF7),
              Color(0xFF9F44D3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                color: Colors.black.withOpacity(0.88),
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [

                        const SizedBox(height: 30),

                        /// PROFILE HEADER
                        _buildProfileHeader(),

                        const SizedBox(height: 30),

                        /// MENU ITEMS
                        _menuItem(
                          context,
                          icon: Icons.person_outline,
                          title: "My Account",
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.push(context,_animatedRoute(ProfileScreen()));
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              _animatedRoute(const MyLibraryScreen()),
                            );
                          },
                        ),

                        _menuItem(
                          context,
                          icon: Icons.edit_outlined,
                          title: "Edit Profile",
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.push(context,_animatedRoute(EditProfileScreen()));
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
                            // Navigator.push(context,_animatedRoute(SubscriptionScreen()));
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              _animatedRoute(const MyLibraryScreen()),
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

                        const SizedBox(height: 30),

                        /// LOGOUT
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

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// PROFILE HEADER
  Widget _buildProfileHeader() {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFF9F44D3),
                Color(0xFF7B2FF7),
              ],
            ),
          ),
          child: const Center(
            child: Text(
              "RP",
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Riddhi Shah",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "0018223778960",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  /// MENU ITEM
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withOpacity(0.06),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isLogout ? Colors.redAccent : Colors.white,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isLogout ? Colors.redAccent : Colors.white,
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

  /// LOGOUT DIALOG
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Add Firebase logout logic here
            },
          ),
        ],
      ),
    );
  }
}
