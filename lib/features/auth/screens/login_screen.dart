import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'package:book_app/core/theme/app_colors.dart';
import 'package:book_app/features/auth/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ✅ SAFE NAVIGATION METHOD
  void _goToAppShell() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AppShell(),
      ),
    );
  }
  /// Navigate to Signup Screen
  void _goToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SignupScreen(),
      ),
    );
  }


  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final success = await context.read<AuthProvider>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (!success) {
      final error = context.read<AuthProvider>().error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Stack(
        children: [

          /// Floating Books
          Positioned(
            top: 100,
            left: 20,
            child: Image.asset(
              "assets/books/Book1.png",
              width: 50,
            ).animate(onPlay: (c) => c.repeat())
              .moveY(begin: -10, end: 10, duration: 3.seconds),
          ),

          Positioned(
            bottom: 200,
            right: 30,
            child: Image.asset(
              "assets/books/Book2.png",
              width: 60,
            ).animate(onPlay: (c) => c.repeat())
              .moveY(begin: 15, end: -15, duration: 4.seconds),
          ),

          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark,
                  AppColors.secondaryDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 80),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book,
                            color: AppColors.premiumYellow,
                            size: 30),
                        SizedBox(width: 10),
                        Text(
                          "Mythica",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    Image.asset(
                      "assets/image/abc.png",
                      height: 180,
                    ),

                    const SizedBox(height: 50),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 35),
                      decoration: const BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [

                            _buildTextField(
                              controller: _emailController,
                              hint: "Email",
                              icon: Icons.email,
                            ),

                            const SizedBox(height: 20),

                            _buildTextField(
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock,
                              isPassword: true,
                            ),

                            const SizedBox(height: 30),

                            _gradientButton(
                              _isLoading ? "Please wait..." : "LOGIN",
                              _handleLogin,
                            ),

                            const SizedBox(height: 30),
                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "Don't have an account? ",
      style: TextStyle(color: AppColors.lightText),
    ),
    GestureDetector(
      onTap: _goToSignUpScreen,
      child: const Text(
        "Sign Up",
        style: TextStyle(
          color: AppColors.premiumYellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 20),


/// Google
_socialButton(
  "Login with Google",
  () async {
    final success = await authProvider.signInWithGoogle();

    if (!mounted) return; // ✅ ensure widget still exists

    if (!success) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Google sign-in failed')),
      );
      return;
    }

    if (authProvider.requiresProfileCompletion) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Please complete your profile setup.')),
      );
    }
  },
),

const SizedBox(height: 12),

/// Microsoft
_socialButton(
  "Login with Outlook",
  () async {
    final success = await authProvider.signInWithMicrosoft();

    if (!mounted) return; // ✅ ensure widget still exists

    if (!success) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Microsoft sign-in failed')),
      );
      return;
    }

    if (authProvider.requiresProfileCompletion) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Please complete your profile setup.')),
      );
    }
  },
),
const SizedBox(height: 12),

                            /// Guest
                            _socialButton(
                              "Continue as Guest",
                              () async {
                                await authProvider.continueAsGuest();
                                if (!mounted) return;

                                if (authProvider.currentUser != null) {
                                  _goToAppShell();
                                }
                              },
                            ),

                            const SizedBox(height: 30),

                            const Text(
                              "Read. Write. Connect. Earn.",
                              style: TextStyle(
                                color: AppColors.premiumYellow,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) {
        final text = value?.trim() ?? '';

        if (hint == 'Email') {
          if (text.isEmpty) return 'Email is required';
          if (!_emailRegex.hasMatch(text)) return 'Enter valid email';
        }

        if (hint == 'Password') {
          if (text.isEmpty) return 'Password is required';
          if (text.length < 6) return 'Minimum 6 characters required';
        }

        return null;
      },
      style: const TextStyle(color: AppColors.lightText),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.premiumYellow),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.secondaryDark,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: AppColors.premiumYellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: AppColors.premiumYellow,
              width: 2),
        ),
      ),
    );
  }

  Widget _gradientButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding:
            const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.premiumYellow,
              AppColors.premiumYellowDark,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          borderRadius:
              BorderRadius.circular(30),
          border: Border.all(
              color: AppColors.premiumYellowDark),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: AppColors.lightText),
          ),
        ),
      ),
    );
  }
}