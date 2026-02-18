import 'package:flutter/material.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

class ReaderScreen extends StatefulWidget {
  final bool isLocked;

  const ReaderScreen({super.key, required this.isLocked});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  double _fontSize = 18;
  bool _isDarkMode = false;
  bool _isSepiaMode = false;
  double _progress = 0;

  final ScrollController _scrollController = ScrollController();

  final String _dummyContent = """
📖 Book content starts here...

This is a professional reader experience.

You can change font size, switch themes, and track your reading progress.

Later API / PDF / text will load here.

Keep scrolling to see progress change.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in neque et nisl.

End of sample content.
""";

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll > 0) {
        setState(() {
          _progress = (currentScroll / maxScroll) * 100;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔒 Locked book redirect
    if (widget.isLocked) return const ReaderSubscriptionScreen();

    // 🎨 Dynamic Theme Colors
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    if (_isDarkMode) {
      bgColor = Colors.black;
      textColor = Colors.white;
    } else if (_isSepiaMode) {
      bgColor = const Color(0xFFF4ECD8);
      textColor = Colors.brown.shade800;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text("Reader"),
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          // 🌙 Dark Mode Toggle
          IconButton(
            icon: Icon(Icons.dark_mode, color: textColor),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
                _isSepiaMode = false;
              });
            },
          ),
          // 📜 Sepia Mode Toggle
          IconButton(
            icon: Icon(Icons.menu_book, color: textColor),
            onPressed: () {
              setState(() {
                _isSepiaMode = !_isSepiaMode;
                _isDarkMode = false;
              });
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Text(
            _dummyContent,
            style: TextStyle(
              fontSize: _fontSize,
              height: 1.8,
              color: textColor,
            ),
          ),
        ),
      ),

      // 📌 Bottom Reading Toolbar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.grey[900] : Colors.black87,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ➖ Decrease Font
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (_fontSize > 14) _fontSize -= 2;
                });
              },
            ),
            // 📊 Reading Progress %
            Text(
              "${_progress.toStringAsFixed(0)}%",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            // ➕ Increase Font
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (_fontSize < 32) _fontSize += 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
