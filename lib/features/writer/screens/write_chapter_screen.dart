import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        elevation: 0,
        title: const Text("Write Chapter"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Chapter Title"),
            _inputField(
              controller: _chapterTitleController,
              hint: "Enter chapter title",
              maxLines: 1,
            ),

            const SizedBox(height: 16),

            _label("Chapter Content"),
            Expanded(
              child: _inputField(
                controller: _chapterContentController,
                hint: "Start writing your chapter here...",
                maxLines: null,
                expands: true,
              ),
            ),

            const SizedBox(height: 16),

            _saveButton(context),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int? maxLines,
    bool expands = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      expands: expands,
      style: const TextStyle(color: Colors.white),
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Chapter saved as draft"),
            ),
          );
          Navigator.pop(context);
        },
        child: const Text(
          "Save Chapter",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
