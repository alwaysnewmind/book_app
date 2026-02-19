import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/navigation/app_shell.dart';
import '../../../providers/auth_provider.dart';
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

  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();

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

  void _goToAppShell(AuthProvider authProvider) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AppShell(
          currentUser: authProvider.currentUser,
          isGuest: authProvider.isGuest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7F00FF),
              Color(0xFFE100FF),
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

                const SizedBox(height: 60),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book,
                        color: Colors.white, size: 28),
                    SizedBox(width: 8),
                    Text(
                      "Mythica",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Image.asset(
                  "assets/image/abc.png",
                  height: 180,
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [

                      AuthTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 20),

                      AuthTextField(
                        controller: _passwordController,
                        hint: "Password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),

                      const SizedBox(height: 25),

                      if (authProvider.error != null)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authProvider.error!,
                            style: const TextStyle(
                                color: Colors.red),
                          ),
                        ),

                      AuthButton(
                        text: authProvider.isLoading
                            ? "Please wait..."
                            : "LOGIN",
                        onTap: authProvider.isLoading
                            ? null
                            : () async {

                                final success =
                                    await authProvider.login(
                                  email:
                                      _emailController.text.trim(),
                                  password:
                                      _passwordController.text.trim(),
                                );
                                  if (!mounted) return;
                                if (success) {
                                  _goToAppShell(authProvider);
                                }
                              },
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Don't have your account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/signup');
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF7F00FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _socialButton(
                        text: "Demo Reader",
                        onTap: () async {
                          await authProvider
                              .demoLoginReader();
                          if (mounted) {
                            _goToAppShell(authProvider);
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      _socialButton(
                        text: "Demo Writer",
                        onTap: () async {
                          await authProvider
                              .demoLoginWriter();
                          if (mounted) {
                            _goToAppShell(authProvider);
                          }
                        },
                      ),

                      const SizedBox(height: 15),

                      _socialButton(
                        text: "Continue as Guest",
                        onTap: () {
                          authProvider.continueAsGuest();
                          _goToAppShell(authProvider);
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
    );
  }

  Widget _socialButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
              BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
