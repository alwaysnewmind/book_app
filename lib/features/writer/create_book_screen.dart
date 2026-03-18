import 'package:book_app/features/writer/moderation/moderation_status.dart';
import 'package:book_app/features/writer/widgets/content_moderation_service.dart'
    show ContentModerationService;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/services/story_service.dart';
import 'package:provider/provider.dart';
import 'package:book_app/features/auth/provider/auth_provider.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  State<CreateBookScreen> createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _descController = TextEditingController();

  bool _isPremium = false;
  bool _isSubmitting = false;
  String _selectedGenre = "Fiction";

  final List<String> _genres = [
    "Fiction",
    "Romance",
    "Thriller",
    "Horror",
    "Self Growth",
    "Business"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _saveStory() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final authProvider = context.read<AuthProvider>();
    final appUser = authProvider.currentUser;

    if (firebaseUser == null || appUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login again to continue.')),
      );
      return;
    }

    final uid = firebaseUser.uid;
    final userName = appUser.name;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content is required')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // ✅ CONTENT MODERATION
      final moderationResult = await ContentModerationService.checkContent(
        _titleController.text.trim(),
        _subtitleController.text.trim(),
        _descController.text.trim(),
      );

      if (moderationResult == ModerationStatus.blocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("❌ Content violates community guidelines.")),
        );
        return;
      }

      if (moderationResult == ModerationStatus.warning) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("⚠️ Content may contain sensitive material.")),
        );
      }

      // ✅ SAVE WITH REAL USER NAME
      await StoryService.instance.createStory(
        uid: uid,
        authorName: userName,
        title: _titleController.text.trim(),
        description: _subtitleController.text.trim(),
        content: _descController.text.trim(),
        genre: _selectedGenre,
        isPremium: _isPremium,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book saved as draft")),
      );

      Navigator.pushNamed(
        context,
        AppRoutes.createBookEntry,
        arguments: {
          'title': _titleController.text.trim(),
          'subtitle': _subtitleController.text.trim(),
          'description': _descController.text.trim(),
          'genre': _selectedGenre,
          'isPremium': _isPremium,
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.select<AuthProvider, String>(
      (provider) => provider.currentUser?.name ?? "User",
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Create Book - $userName",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF5C84C)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1533), Color(0xFF2A1E47)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 210,
                  width: 155,
                  decoration: BoxDecoration(
                    color: const Color(0xFF251A3F),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF3A2D5C)),
                  ),
                  child: const Center(
                    child: Icon(Icons.add_a_photo_outlined,
                        color: Color(0xFFCFC8E8), size: 42),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              _label("BOOK TITLE"),
              _inputField(
                  controller: _titleController, hint: "Enter book title"),

              const SizedBox(height: 22),

              _label("SUBTITLE"),
              _inputField(
                  controller: _subtitleController,
                  hint: "Optional subtitle"),

              const SizedBox(height: 22),

              _label("GENRE"),
              _genreDropdown(),

              const SizedBox(height: 22),

              _label("DESCRIPTION"),
              _inputField(
                controller: _descController,
                hint: "Write short description...",
                maxLines: 4,
              ),

              const SizedBox(height: 26),

              _premiumToggle(),

              const SizedBox(height: 42),

              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF9F96C8),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
        filled: true,
        fillColor: const Color(0xFF251A3F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF3A2D5C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              const BorderSide(color: Color(0xFFF5C84C), width: 1.2),
        ),
      ),
    );
  }

  Widget _genreDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: DropdownButton<String>(
        value: _selectedGenre,
        dropdownColor: const Color(0xFF251A3F),
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down,
            color: Color(0xFFF5C84C)),
        style: const TextStyle(color: Colors.white),
        items: _genres.map((genre) {
          return DropdownMenuItem(
            value: genre,
            child: Text(genre),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedGenre = value);
          }
        },
      ),
    );
  }

  Widget _premiumToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        activeColor: const Color(0xFFF5C84C),
        value: _isPremium,
        title: const Text(
          "Mark as Premium Book",
          style: TextStyle(color: Colors.white),
        ),
        onChanged: (value) => setState(() => _isPremium = value),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: _isSubmitting ? null : _saveStory,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF5C84C),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Center(
            child: _isSubmitting
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text(
                    "Save & Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1533),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}