import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:book_app/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';
import 'package:provider/provider.dart';

class ReaderScreen extends StatefulWidget {
  final bool isLocked;
  final ReaderBookModel? book;

  const ReaderScreen({super.key, required this.isLocked, this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  double _progress = 0;
  final ScrollController _scrollController = ScrollController();
  final ReaderController _readerController = ReaderController();

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
    _readerController.init();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeReader());

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;

      if (maxScroll > 0) {
        final progress = (currentScroll / maxScroll) * 100;
        setState(() {
          _progress = progress;
        });

        context.read<ReaderProvider>().updateProgress(progress);
        final activeBook = widget.book;
        if (activeBook != null) {
          _readerController.updateReadingProgress(
            bookId: activeBook.id,
            progress: progress,
            pagesRead: 1,
          );
        }
      }
    });
  }

  Future<void> _initializeReader() async {
    final book = widget.book;
    if (book == null) {
      await context.read<ReaderProvider>().openBook(
            book: const ReaderBookModel(
              id: 'demo_reader_book',
              title: 'Reader Demo',
              description: 'Demo content for reader engine',
              authorName: 'System',
              coverUrl: 'assets/covers/atomic.jpg',
              genre: 'Demo',
              rating: 5,
              totalChapters: 1,
              lastReadChapter: 1,
              progressPercent: 0,
              viewsCount: 0,
              isBookmarked: false,
              lastReadAt: null,
            ),
            content: _dummyContent,
          );
      return;
    }

    await _readerController.openBook(book);
    await context.read<ReaderProvider>().openBook(
          book: book,
          content: _readerController.currentBookContent,
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _readerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLocked) return const ReaderSubscriptionScreen();

    return Consumer<ReaderProvider>(
      builder: (context, provider, _) {
        Color bgColor = Colors.white;
        Color textColor = Colors.black;

        if (provider.darkMode) {
          bgColor = Colors.black;
          textColor = Colors.white;
        } else if (provider.sepiaMode) {
          bgColor = const Color(0xFFF4ECD8);
          textColor = Colors.brown.shade800;
        }

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            title: const Text('Reader'),
            iconTheme: IconThemeData(color: textColor),
            titleTextStyle: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.dark_mode, color: textColor),
                onPressed: provider.toggleDarkMode,
              ),
              IconButton(
                icon: Icon(Icons.menu_book, color: textColor),
                onPressed: provider.toggleSepiaMode,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Text(
                provider.currentBookContent.isEmpty ? _dummyContent : provider.currentBookContent,
                style: TextStyle(
                  fontSize: provider.fontSize,
                  height: 1.8,
                  color: textColor,
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: provider.darkMode ? Colors.grey[900] : Colors.black87,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: provider.decreaseFont,
                ),
                Text(
                  '${_progress.toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: provider.increaseFont,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
