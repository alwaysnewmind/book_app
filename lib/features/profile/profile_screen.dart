import 'package:flutter/material.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_menu.dart';

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
                      child: const ProfileStats(),
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
                      child: const ProfileMenu(),
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
                              ? "Switch to Reader Mode"
                              : "Switch to Writer Mode",
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
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
