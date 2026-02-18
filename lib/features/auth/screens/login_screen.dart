import 'package:flutter/material.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/navigation/app_shell.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Demo user for testing
  AppUser get demoUser => AppUser(
        uid: "demo123",
        email: "demo@bookapp.com",
        name: "Demo User",
        role: UserRole.reader,
        isPremium: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 12,
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.menu_book, size: 60, color: Colors.amber),
                      const SizedBox(height: 12),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email
                      const AuthTextField(
                        hint: "Email or Phone",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      const AuthTextField(
                        hint: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      AuthButton(
                        text: "Login",
                        onTap: () {
                          // Navigate with demo user
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppShell(
                                currentUser: demoUser,
                                isGuest: false,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Sign Up Redirect
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Demo Guest Login
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AppShell(
                                currentUser: null,
                                isGuest: true,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Continue as Guest",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
