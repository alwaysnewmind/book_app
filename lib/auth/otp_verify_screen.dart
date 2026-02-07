import 'package:flutter/material.dart';
import 'set_password_screen.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Enter 6-digit OTP"),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SetPasswordScreen()),
                );
              },
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
