import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

// Dummy chapter model
class Chapter {
  String title;
  Chapter(this.title);
}

// Dummy book model
class Book {
  String title;
  String description;
  String? coverImage;
  List<Chapter> chapters;
  Book({required this.title, required this.description, this.coverImage, required this.chapters});
}

class WriterPublishPage extends StatefulWidget {
  const WriterPublishPage({super.key});

  @override
  State<WriterPublishPage> createState() => _WriterPublishPageState();
}

class _WriterPublishPageState extends State<WriterPublishPage> {
  final Book book = Book(
    title: "Untitled Book",
    description: "",
    chapters: [Chapter("Chapter 1")],
  );

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Timer? _autoSaveTimer;

  @override
  void initState() {
    super.initState();
    _titleController.text = book.title;
    _descController.text = book.description;

    // Auto-save draft every 10 seconds
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _autoSaveDraft();
    });
  }

  void _autoSaveDraft() {
    // Simulate backend save
    print("Auto-saved draft: ${_titleController.text}");
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addChapter() {
    setState(() {
      book.chapters.add(Chapter("Chapter ${book.chapters.length + 1}"));
    });
  }

  void _moveChapterUp(int index) {
    if (index > 0) {
      setState(() {
        final temp = book.chapters[index - 1];
        book.chapters[index - 1] = book.chapters[index];
        book.chapters[index] = temp;
      });
    }
  }

  void _moveChapterDown(int index) {
    if (index < book.chapters.length - 1) {
      setState(() {
        final temp = book.chapters[index + 1];
        book.chapters[index + 1] = book.chapters[index];
        book.chapters[index] = temp;
      });
    }
  }

  void _showCoverGenerator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CoverPageGeneratorSheet(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Publish Book"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Metadata
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Book Title",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Book Description",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              /// Generate Cover Page
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.photo),
                label: const Text(
                  "Generate Cover Page",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _showCoverGenerator,
              ),
              const SizedBox(height: 24),

              /// Chapters
              const Text(
                "Chapters",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// Netflix-style chapter cards without package
              Column(
                children: List.generate(book.chapters.length, (index) {
                  final chapter = book.chapters[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.deepPurpleAccent,
                        image: const DecorationImage(
                          image: AssetImage("assets/book_placeholder.png"),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    chapter.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward,
                                            color: Colors.white),
                                        onPressed: () => _moveChapterUp(index),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_downward,
                                            color: Colors.white),
                                        onPressed: () =>
                                            _moveChapterDown(index),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              ElevatedButton.icon(
                onPressed: _addChapter,
                icon: const Icon(Icons.add),
                label: const Text("Add Chapter"),
              ),
              const SizedBox(height: 32),

              /// Publish Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Book Published!")),
                    );
                  },
                  child: const Text(
                    "Publish Book",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cover Page Generator
class _CoverPageGeneratorSheet extends StatelessWidget {
  final Book book;
  const _CoverPageGeneratorSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          controller: scrollController,
          children: [
            const Center(
              child: Text(
                "Cover Page Generator",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Image"),
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Generate AI Cover"),
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Cover Preview Here",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
