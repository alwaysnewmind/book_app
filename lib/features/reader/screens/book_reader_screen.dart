import 'package:flutter/material.dart';
import 'package:book_app/features/library/models/library_book.dart';

class BookReaderScreen extends StatefulWidget {
  final LibraryBook book;

  const BookReaderScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  double fontSize = 18;
  bool isDarkMode = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // ✅ Continue Reading Support
    _scrollController = ScrollController(
      initialScrollOffset: widget.book.lastScrollOffset,
    );

    _scrollController.addListener(() {
      widget.book.lastScrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          widget.book.title,
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bookmark Saved")),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
          PopupMenuButton<double>(
            icon: const Icon(Icons.text_fields),
            onSelected: (value) {
              setState(() {
                fontSize = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 16, child: Text("Small")),
              PopupMenuItem(value: 18, child: Text("Medium")),
              PopupMenuItem(value: 22, child: Text("Large")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: _scrollController, // ✅ Important
          child: Text(
            widget.book.content,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.6,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
