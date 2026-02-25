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
      backgroundColor: const Color(0xFF1F1533),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
              Color(0xFF140F26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// Luxury Header
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Color(0xFFF5C84C), size: 26),
                    SizedBox(width: 14),
                    Text(
                      "Write Chapter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              /// Main Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF251A3F),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    border: Border(
                      top: BorderSide(color: Color(0xFF3A2D5C), width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Chapter Title"),
                      _inputField(
                        controller: _chapterTitleController,
                        hint: "Enter chapter title",
                        maxLines: 1,
                      ),

                      const SizedBox(height: 28),

                      _label("Chapter Content"),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _inputField(
                          controller: _chapterContentController,
                          hint: "Start writing your chapter here...",
                          maxLines: null,
                          expands: true,
                        ),
                      ),

                      const SizedBox(height: 28),

                      _saveButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFCFC8E8),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF251A3F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF3A2D5C)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        expands: expands,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        cursorColor: Color(0xFFF5C84C),
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ).copyWith(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF9F96C8),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5C84C),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4DFFD76A), // 30% opacity glow
              blurRadius: 18,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFF251A3F),
                content: Text(
                  "Chapter saved as draft",
                  style: TextStyle(color: Color(0xFFCFC8E8)),
                ),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text(
            "Save Chapter",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F1533),
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}