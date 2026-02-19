import 'package:flutter/material.dart';
import 'package:book_app/models/user_model.dart';
import 'package:book_app/features/writer/screens/writer_dashboard.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUpDemo() {
  final now = DateTime.now();

  final demoUser = AppUser(
    uid: "demo_signup",
    name: _nameController.text.trim().isEmpty
        ? "Demo Writer"
        : _nameController.text.trim(),
    email: _emailController.text.trim().isEmpty
        ? "demo@signup.com"
        : _emailController.text.trim(),

    role: UserRole.writer,
    currentMode: UserMode.writer,

    createdAt: now,
    updatedAt: now,

    // Required but not in your snippet
    hasCompletedOnboarding: false,
    selectedGenres: [],

    // Optional fields (explicit for safety)
    photoUrl: null,
    profileImageUrl: null,
    isPremium: false,
    subscriptionExpiry: null,
    writerTrialStart: now,
    isWriterPremium: false,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WriterDashboard(
          currentUser: demoUser,
          isGuest: false, isWriterMode: true,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Stack(
              children: [
                // Gradient Header
                Container(
                  height: size.height * 0.4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // Form Card
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _nameController,
                              decoration:
                                  _inputDecoration("Full Name"),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _emailController,
                              decoration:
                                  _inputDecoration("Email"),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _passwordController,
                              decoration:
                                  _inputDecoration("Password"),
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: signUpDemo,
                                style: ElevatedButton.styleFrom(
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  backgroundColor:
                                      const Color(0xFF6C63FF),
                                ),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: const Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                    color: Color(0xFF6C63FF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
