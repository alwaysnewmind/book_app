import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/features/writer/provider/writer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/features/writer/moderation/moderation_status.dart';

class WriteChapterScreen extends StatefulWidget {
  const WriteChapterScreen({super.key});

  @override
  State<WriteChapterScreen> createState() => _WriteChapterScreenState();
}

class _WriteChapterScreenState extends State<WriteChapterScreen> {
  final _chapterTitleController = TextEditingController();
  final _chapterContentController = TextEditingController();

  @override
  void dispose() {
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final title = _chapterTitleController.text.trim();
    final content = _chapterContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both title and content.")),
      );
      return;
    }

    final provider = context.read<WriterProvider>();

    // -----------------------------
    // Content Moderation
    // -----------------------------
    final status = await provider.validateContentSafety(
      title: title,
      description: '',
      content: content,
    );

    if (status == ModerationStatus.blocked) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Content rejected: Prohibited material detected."),
        ),
      );
      return;
    }

    if (status == ModerationStatus.warning) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("⚠️ Content may contain sensitive material."),
        ),
      );
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      AppRoutes.writerPublish,
      arguments: {
        ...args,
        'chapterTitle': title,
        'chapterContent': content,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1533), Color(0xFF2A1E47), Color(0xFF140F26)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  _header(),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF251A3F),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                        border: Border(top: BorderSide(color: Color(0xFF3A2D5C), width: 1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Chapter Title"),
                          _inputField(_chapterTitleController, "Enter chapter title", 1, false),
                          const SizedBox(height: 28),
                          _label("Chapter Content"),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _inputField(
                              _chapterContentController,
                              "Start writing...",
                              null,
                              true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Consumer<WriterProvider>(
                            builder: (context, provider, _) =>
                                _saveButton(provider.isActionLoading),
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
      ),
    );
  }

  Widget _header() => Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF5C84C)),
            ),
            const SizedBox(width: 14),
            const Text(
              "Write Chapter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFCFC8E8),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _inputField(TextEditingController controller, String hint, int? maxLines, bool expands) =>
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1533),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF3A2D5C)),
        ),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          expands: expands,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          cursorColor: const Color(0xFFF5C84C),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9F96C8)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      );

  Widget _saveButton(bool isLoading) => SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5C84C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: isLoading ? null : _handleSave,
          child: isLoading
              ? const CircularProgressIndicator(color: Color(0xFF1F1533))
              : const Text(
                  "Save Chapter",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1533)),
                ),
        ),
      );
}