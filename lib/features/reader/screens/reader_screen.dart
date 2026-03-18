import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:book_app/features/reader/provider/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';
import 'package:provider/provider.dart';

class ReaderScreen extends StatefulWidget {
  final bool isLocked;
  final ReaderBookModel? book;

  const ReaderScreen({
    super.key,
    required this.isLocked,
    this.book,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {

  final ScrollController _scrollController = ScrollController();
  final ReaderController _readerController = ReaderController();

  double _progress = 0;

  final String _dummyContent = """
📖 Book content starts here...

This is a professional reader experience.

You can change font size, switch themes, and track your reading progress.

Later API / PDF / text will load here.

Keep scrolling to see progress change.

Lorem ipsum dolor sit amet, consectetur adipiscing elit.

End of sample content.
""";

  @override
  void initState() {
    super.initState();

    _readerController.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReader();
    });

    _scrollController.addListener(_handleScroll);
  }

  /// SCROLL PROGRESS
  void _handleScroll() {

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (maxScroll <= 0) return;

    final progress = (currentScroll / maxScroll) * 100;

    setState(() {
      _progress = progress;
    });

    final activeBook = widget.book;

    if (activeBook != null) {
      _readerController.updateReadingProgress(
        bookId: activeBook.id,
        progress: progress,
        pagesRead: 1,
      );
    }
  }

  /// INIT READER
  Future<void> _initializeReader() async {

    final book = widget.book;

    if (book == null) {

      await context.read<ReaderProvider>().openBook(
            book: const ReaderBookModel(
              id: 'demo_reader_book',
              title: 'Reader Demo',
              description: 'Demo content',
              authorName: 'System',
              coverUrl: '',
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

    if (!mounted) return;

       
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _readerController.dispose();
    super.dispose();
  }

  /// THEME HELPER
  (Color, Color) _resolveTheme(ReaderProvider provider) {

    switch (provider.themeMode) {

      case ReaderThemeMode.dark:
        return (Colors.black, Colors.white);

      case ReaderThemeMode.sepia:
        return (const Color(0xFFF4ECD8), Colors.brown);

      case ReaderThemeMode.light:
        return (Colors.white, Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.isLocked) {
      return const ReaderSubscriptionScreen();
    }

    return Consumer<ReaderProvider>(
      builder: (context, provider, _) {

        final (bgColor, textColor) = _resolveTheme(provider);

        return Scaffold(
          backgroundColor: bgColor,

          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),

            title: Text(
              provider.currentBook?.title ?? "Reader",
              style: TextStyle(color: textColor),
            ),

            actions: [

              /// DARK MODE
              IconButton(
                icon: Icon(Icons.dark_mode, color: textColor),
                onPressed: () {
                  provider.changeTheme(ReaderThemeMode.dark);
                },
              ),

              /// SEPIA
              IconButton(
                icon: Icon(Icons.menu_book, color: textColor),
                onPressed: () {
                  provider.changeTheme(ReaderThemeMode.sepia);
                },
              ),

              /// LIGHT
              IconButton(
                icon: Icon(Icons.light_mode, color: textColor),
                onPressed: () {
                  provider.changeTheme(ReaderThemeMode.light);
                },
              ),
            ],
          ),

          /// CONTENT
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),

              child: Text(
                provider.currentBookContent.isEmpty
                    ? _dummyContent
                    : provider.currentBookContent,

                style: TextStyle(
                  fontSize: provider.fontSize,
                  height: 1.8,
                  color: textColor,
                ),
              ),
            ),
          ),

          /// BOTTOM BAR
          bottomNavigationBar: Container(

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

            color: provider.themeMode == ReaderThemeMode.dark
                ? Colors.grey[900]
                : Colors.black87,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: provider.decreaseFont,
                ),

                Text(
                  "${_progress.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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