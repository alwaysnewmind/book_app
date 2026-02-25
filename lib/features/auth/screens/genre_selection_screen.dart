import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/providers/auth_provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState
    extends State<RoleSelectionScreen> {

  String? selectedRole;

  Future<void> _handleRoleSelection(String role) async {
    setState(() {
      selectedRole = role;
    });

    final authProvider = context.read<AuthProvider>();
    await authProvider.setUserRole(role);

    if (!mounted) return;

    if (role == "reader") {
      Navigator.pushReplacementNamed(context, AppRoutes.readerGenres);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.writerGenres);
    }
  }

  Widget roleCard({
    required String role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () => _handleRoleSelection(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF24163A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD86B)
                : const Color(0xFF5C4A80),
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFFFFD86B)
                    .withOpacity(0.45),
                blurRadius: 25,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFFFFD86B),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB8AFCF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E1B47),
              Color(0xFF1F1533),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [

                const SizedBox(height: 60),

                const Text(
                  "Choose Your Experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "How would you like to continue?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFB8AFCF),
                  ),
                ),

                const SizedBox(height: 60),

                roleCard(
                  role: "reader",
                  title: "Continue as Reader",
                  subtitle:
                      "Explore, read and enjoy thousands of books",
                  icon: Icons.menu_book,
                ),

                const SizedBox(height: 30),

                roleCard(
                  role: "writer",
                  title: "Continue as Writer",
                  subtitle:
                      "Create, publish and earn from your stories",
                  icon: Icons.edit,
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}