import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0E1A1A),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // 👤 PROFILE HEADER
          const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile/male.png'),
          ),
          const SizedBox(height: 12),

          const Text(
            'Rahul Patel',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 4),

          const Text(
            '+91 9XXXXXXXXX',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),

          const SizedBox(height: 30),

          // 📂 MENU
          _item(Icons.person, 'My Account'),
          _item(Icons.edit, 'Edit Profile'),
          _item(Icons.subscriptions, 'My Subscription'),
          _item(Icons.library_books, 'My Library'),
          _item(Icons.settings, 'Settings'),

          const Spacer(),

          _item(Icons.logout, 'Logout', isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.white,
        ),
      ),
      onTap: () {},
    );
  }
}
