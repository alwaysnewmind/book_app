import 'dart:async';
import 'package:flutter/material.dart';

class CreateBookPage extends StatefulWidget {
  const CreateBookPage({super.key});

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _chapterTitleController = TextEditingController();
  final TextEditingController _chapterContentController = TextEditingController();

  List<Map<String, String>> _chapters = [];

  Timer? _autoSaveTimer;

  bool _isSaved = true;
  bool _isPublished = false;
  bool _isMonetized = false;

  int get _wordCount {
    if (_chapterContentController.text.trim().isEmpty) return 0;
    return _chapterContentController.text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    _startAutoSave();
  }

  void _startAutoSave() {
    _autoSaveTimer =
        Timer.periodic(const Duration(seconds: 8), (_) => _saveDraft());
  }

  void _saveDraft() {
    if (!_isSaved) {
      setState(() => _isSaved = true);
    }
  }

  void _onTextChanged() {
    if (_isSaved) {
      setState(() => _isSaved = false);
    }
  }

  void _addOrUpdateChapter() {
    final title = _chapterTitleController.text.trim();
    final content = _chapterContentController.text.trim();

    if (title.isEmpty || content.isEmpty) return;

    setState(() {
      _chapters.add({'title': title, 'content': content});
      _chapterTitleController.clear();
      _chapterContentController.clear();
      _isSaved = false;
    });

    _saveDraft();
  }

  void _editChapter(int index) {
    final chapter = _chapters[index];
    _chapterTitleController.text = chapter['title'] ?? "";
    _chapterContentController.text = chapter['content'] ?? "";

    setState(() {
      _chapters.removeAt(index);
    });
  }

  void _deleteChapter(int index) {
    setState(() {
      _chapters.removeAt(index);
      _isSaved = false;
    });
  }

  void _publishBook() {
    final title = _bookTitleController.text.trim();

    if (title.isEmpty || _chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add book title & at least one chapter"),
        ),
      );
      return;
    }

    setState(() {
      _isPublished = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Book Published Successfully 🚀")),
    );
  }

  void _reorderChapter(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _chapters.removeAt(oldIndex);
      _chapters.insert(newIndex, item);
      _isSaved = false;
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _bookTitleController.dispose();
    _chapterTitleController.dispose();
    _chapterContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFFB57EEB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.white),
                    const Spacer(),
                    Icon(
                      _isSaved ? Icons.check_circle : Icons.sync_problem,
                      color: _isSaved ? Colors.green : Colors.orange,
                      size: 18,
                    ),
                  ],
                ),
              ),

              /// WHITE CARD
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Create New Book",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextField(
                          controller: _bookTitleController,
                          onChanged: (_) => _onTextChanged(),
                          decoration: _modernInput("Title"),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: _chapterTitleController,
                          onChanged: (_) => _onTextChanged(),
                          decoration: _modernInput("Chapter Title"),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: _chapterContentController,
                          onChanged: (_) => _onTextChanged(),
                          maxLines: 6,
                          decoration: _modernInput("Write chapter here..."),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Word Count: $_wordCount",
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _addOrUpdateChapter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A5AE0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("Add Chapter"),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Chapters",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 170,
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _chapters.length,
                            onReorder: _reorderChapter,
                            itemBuilder: (context, index) {
                              final chapter = _chapters[index];

                              return Container(
                                key: ValueKey(chapter),
                                width: 160,
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F1FF),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chapter['title'] ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              size: 18),
                                          onPressed: () =>
                                              _editChapter(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.redAccent,
                                              size: 18),
                                          onPressed: () =>
                                              _deleteChapter(index),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _publishBook,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6A5AE0),
                                    Color(0xFFB57EEB),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  "Publish Book",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _modernInput(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F1FF),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }
}
