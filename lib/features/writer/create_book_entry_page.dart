import 'dart:async';
import 'dart:ui';
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
      debugPrint("Auto Saving Draft...");
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
      backgroundColor: Colors.deepPurple[900],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            const Text("Create Book"),
            const SizedBox(width: 12),
            Icon(
              _isSaved ? Icons.check_circle : Icons.sync_problem,
              color: _isSaved ? Colors.green : Colors.orange,
              size: 18,
            ),
            const SizedBox(width: 12),
            if (_isPublished)
              const Text("Published",
                  style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isMonetized ? Icons.lock_open : Icons.lock,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isMonetized = !_isMonetized;
              });
            },
          ),
          TextButton(
            onPressed: _saveDraft,
            child: const Text("Save",
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: _publishBook,
            child: const Text(
              "Publish",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          /// LEFT PANEL - AI
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.deepPurple[800]?.withOpacity(0.3),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Assistant",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text("• Grammar Check",
                      style: TextStyle(color: Colors.white70)),
                  Text("• Improve Writing",
                      style: TextStyle(color: Colors.white70)),
                  Text("• Generate Ideas",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),

          /// RIGHT PANEL - WRITING
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BOOK TITLE
                  TextField(
                    controller: _bookTitleController,
                    onChanged: (_) => _onTextChanged(),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Book Title"),
                  ),
                  const SizedBox(height: 16),

                  /// CHAPTER TITLE
                  TextField(
                    controller: _chapterTitleController,
                    onChanged: (_) => _onTextChanged(),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Chapter Title"),
                  ),
                  const SizedBox(height: 16),

                  /// CONTENT
                  TextField(
                    controller: _chapterContentController,
                    onChanged: (_) => _onTextChanged(),
                    maxLines: 8,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Write chapter here..."),
                  ),

                  const SizedBox(height: 8),

                  Text("Word Count: $_wordCount",
                      style:
                          const TextStyle(color: Colors.white70)),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addOrUpdateChapter,
                      child: const Text("Add Chapter"),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Chapters",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
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
                            color: Colors.deepPurple[700],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter['title'] ?? "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white70),
                                    onPressed: () =>
                                        _editChapter(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.deepPurple[700],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
