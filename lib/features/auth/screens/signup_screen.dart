import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _selectedGender;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dobController.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }

  Future<void> _signup() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print("USER CREATED: ${userCredential.user?.uid}");

    if (!mounted) return;

    // Success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created successfully")),
    );

    // Navigate after successful signup
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.genreSelection,
    );

  } on FirebaseAuthException catch (e) {
    print("ERROR CODE: ${e.code}");
    print("ERROR MESSAGE: ${e.message}");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Signup failed")),
    );

  } catch (e) {
    print("GENERAL ERROR: $e");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong")),
    );

  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.lightText),
      prefixIcon: Icon(icon, color: AppColors.premiumYellow),
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppColors.premiumYellow, width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Logo
                const Icon(
                  Icons.menu_book_rounded,
                  size: 70,
                  color: AppColors.premiumYellow,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create Premium Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 30),

                /// FORM CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: AppColors.white),
                          decoration:
                              _inputDecoration("Full Name", Icons.person),
                          validator: (v) =>
                              v!.isEmpty ? "Enter your name" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: AppColors.white),
                          decoration:
                              _inputDecoration("Email", Icons.email),
                          validator: (v) =>
                              v!.contains("@") ? null : "Enter valid email",
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _phoneController,
                          style: const TextStyle(color: AppColors.white),
                          decoration:
                              _inputDecoration("Phone", Icons.phone),
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v!.length < 10 ? "Enter valid phone" : null,
                        ),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          dropdownColor: AppColors.cardDark,
                          value: _selectedGender,
                          decoration: _inputDecoration(
                              "Gender", Icons.person_outline),
                          items: ["Male", "Female", "Other"]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: const TextStyle(
                                          color: AppColors.white)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _selectedGender = value);
                          },
                          validator: (v) =>
                              v == null ? "Select gender" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          style: const TextStyle(color: AppColors.white),
                          decoration:
                              _inputDecoration("Date of Birth", Icons.calendar_today),
                          onTap: _selectDate,
                          validator: (v) =>
                              v!.isEmpty ? "Select date of birth" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _cityController,
                          style: const TextStyle(color: AppColors.white),
                          decoration:
                              _inputDecoration("City", Icons.location_city),
                          validator: (v) =>
                              v!.isEmpty ? "Enter city" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppColors.white),
                          decoration: _inputDecoration(
                            "Create Password",
                            Icons.lock,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.premiumYellow,
                              ),
                              onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) =>
                              v!.length < 6 ? "Min 6 characters" : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(color: AppColors.white),
                          decoration: _inputDecoration(
                            "Confirm Password",
                            Icons.lock_outline,
                          ),
                          validator: (v) =>
                              v != _passwordController.text
                                  ? "Passwords do not match"
                                  : null,
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.premiumYellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isLoading ? null : _signup,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : const Text(
                                    "CREATE ACCOUNT",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: AppColors.lightText),
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