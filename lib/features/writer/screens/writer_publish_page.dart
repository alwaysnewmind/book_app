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
  Book({
    required this.title,
    required this.description,
    this.coverImage,
    required this.chapters,
  });
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

    _autoSaveTimer =
        Timer.periodic(const Duration(seconds: 10), (timer) {
      _autoSaveDraft();
    });
  }

  void _autoSaveDraft() {
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
      book.chapters
          .add(Chapter("Chapter ${book.chapters.length + 1}"));
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
      backgroundColor: const Color(0xFF1F1533),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Publish Book",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                _luxuryInput(
                  controller: _titleController,
                  label: "Book Title",
                ),
                const SizedBox(height: 20),

                /// DESCRIPTION
                _luxuryInput(
                  controller: _descController,
                  label: "Book Description",
                  maxLines: 4,
                ),

                const SizedBox(height: 28),

                /// GENERATE COVER
                _goldButton(
                  icon: Icons.photo,
                  text: "Generate Cover Page",
                  onPressed: _showCoverGenerator,
                ),

                const SizedBox(height: 36),

                const Text(
                  "Chapters",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Column(
                  children:
                      List.generate(book.chapters.length, (index) {
                    final chapter = book.chapters[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 18),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF251A3F),
                          borderRadius:
                              BorderRadius.circular(26),
                          border: Border.all(
                              color:
                                  const Color(0xFF3A2D5C)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x4DFFD76A),
                              blurRadius: 20,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(26),
                                child: Image.asset(
                                  "assets/book_placeholder.png",
                                  fit: BoxFit.cover,
                                  color: const Color(
                                          0xFF1F1533)
                                      .withOpacity(0.6),
                                  colorBlendMode:
                                      BlendMode.darken,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.all(16),
                                decoration:
                                    const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(
                                            26),
                                    bottomRight:
                                        Radius.circular(
                                            26),
                                  ),
                                  gradient:
                                      LinearGradient(
                                    begin:
                                        Alignment.topCenter,
                                    end: Alignment
                                        .bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF140F26),
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Text(
                                      chapter.title,
                                      style:
                                          const TextStyle(
                                        color:
                                            Color(0xFFFFFFFF),
                                        fontWeight:
                                            FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(
                                            Icons
                                                .arrow_upward,
                                            color: Color(
                                                0xFFF5C84C),
                                          ),
                                          onPressed: () =>
                                              _moveChapterUp(
                                                  index),
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(
                                            Icons
                                                .arrow_downward,
                                            color: Color(
                                                0xFFF5C84C),
                                          ),
                                          onPressed: () =>
                                              _moveChapterDown(
                                                  index),
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

                const SizedBox(height: 12),

                _secondaryButton(
                  icon: Icons.add,
                  text: "Add Chapter",
                  onPressed: _addChapter,
                ),

                const SizedBox(height: 42),

                Center(
                  child: _goldButton(
                    text: "Publish Book",
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                            content:
                                Text("Book Published!")),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// LUXURY INPUT
  Widget _luxuryInput({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: Color(0xFFCFC8E8)),
        filled: true,
        fillColor: const Color(0xFF251A3F),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide:
              const BorderSide(color: Color(0xFF3A2D5C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide:
              const BorderSide(color: Color(0xFFF5C84C)),
        ),
      ),
    );
  }

  /// PRIMARY GOLD BUTTON
  Widget _goldButton({
    IconData? icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFFF5C84C),
        foregroundColor: const Color(0xFF1F1533),
        minimumSize:
            const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        shadowColor: const Color(0x4DFFD76A),
      ),
      icon:
          icon != null ? Icon(icon) : const SizedBox(),
      label: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    );
  }

  /// SECONDARY BUTTON
  Widget _secondaryButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        minimumSize:
            const Size(double.infinity, 52),
        backgroundColor:
            const Color(0xFF251A3F),
        side: const BorderSide(
            color: Color(0xFF3A2D5C)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      icon: Icon(icon,
          color: const Color(0xFFCFC8E8)),
      label: Text(
        text,
        style: const TextStyle(
            color: Color(0xFFCFC8E8)),
      ),
      onPressed: onPressed,
    );
  }
}

/// COVER PAGE GENERATOR SHEET
class _CoverPageGeneratorSheet extends StatelessWidget {
  final Book book;
  const _CoverPageGeneratorSheet(
      {required this.book});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) =>
          Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1F1533),
              Color(0xFF2A1E47),
            ],
          ),
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: scrollController,
          children: [

            const Center(
              child: Text(
                "Cover Page Generator",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFF5C84C),
                foregroundColor:
                    const Color(0xFF1F1533),
                minimumSize:
                    const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                shadowColor:
                    const Color(0x4DFFD76A),
              ),
              icon: const Icon(Icons.upload_file),
              label: const Text(
                "Upload Image",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFF5C84C),
                foregroundColor:
                    const Color(0xFF1F1533),
                minimumSize:
                    const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                shadowColor:
                    const Color(0x4DFFD76A),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Text(
                "Generate AI Cover",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {},
            ),

            const SizedBox(height: 28),

            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF251A3F),
                borderRadius:
                    BorderRadius.circular(24),
                border: Border.all(
                    color: const Color(0xFF3A2D5C)),
              ),
              child: const Center(
                child: Text(
                  "Cover Preview Here",
                  style: TextStyle(
                    color: Color(0xFF9F96C8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
