import 'dart:io';

import 'package:book_app/navigation/app_shell.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUploadScreen extends StatefulWidget {
  const ProfileUploadScreen({super.key});

  @override
  State<ProfileUploadScreen> createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    final authProvider = context.read<AuthProvider>();
    final uid = authProvider.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('User not found')));
      return;
    }

    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(File(picked.path));
      final downloadUrl = await ref.getDownloadURL();

      await authProvider.savePhotoUrl(downloadUrl);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture uploaded')),
      );

      _goToHome();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isUploading ? null : _pickAndUploadImage,
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload from Gallery'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _isUploading ? null : _goToHome,
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
