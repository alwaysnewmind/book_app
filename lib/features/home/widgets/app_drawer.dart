import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:book_app/features/settings/screens/settings_screen.dart';

// Screens (IMPORT KARNA NA BHOOLNA)
import '../../library/screens/my_library_screen.dart';
// Future screens yaha add karenge:
// import '../../profile/screens/profile_screen.dart';
// import '../../profile/screens/edit_profile_screen.dart';
// import '../../subscription/screens/subscription_screen.dart';
// import '../../settings/screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(animation);

        final fade = Tween(begin: 0.0, end: 1.0).animate(animation);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0E1A1A).withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // 👤 PROFILE HEADER
                const CircleAvatar(
                  radius: 42,
                  backgroundImage:
                      AssetImage('assets/profile/male.png'),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Rahul Patel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  '+91 9XXXXXXXXX',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 30),

                // 📂 MENU ITEMS
                _drawerItem(
                  context,
                  icon: Icons.person,
                  title: 'My Account',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(context,_animatedRoute(ProfileScreen()));
                  },
                ),

                _drawerItem(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(context,_animatedRoute(EditProfileScreen()));
                  },
                ),

                _drawerItem(
                  context,
                  icon: Icons.subscriptions,
                  title: 'My Subscription',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(context,_animatedRoute(SubscriptionScreen()));
                  },
                ),

                _drawerItem(
                  context,
                  icon: Icons.library_books,
                  title: 'My Library',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      _animatedRoute(const MyLibraryScreen()),
                    );
                  },
                ),

                _drawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(context, _animatedRoute(const SettingsScreen()),);
                    // Navigator.push(context,_animatedRoute(SettingsScreen()));
                  },
                ),

                const Spacer(),

                _drawerItem(
                  context,
                  icon: Icons.logout,
                  title: 'Logout',
                  isLogout: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: Colors.deepPurple.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isLogout ? Colors.red : Colors.white,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isLogout ? Colors.red : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
