import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_app/features/reader/provider/reader_provider.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/subscription/reader_subscription_screen.dart';

class BookReaderScreen extends StatefulWidget {
  final LibraryBook book;
  final bool isLocked;

  const BookReaderScreen({
    super.key,
    required this.book,
    this.isLocked = false,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late final List<String> chapters;

  @override
  void initState() {
    super.initState();

    /// Fallback demo chapters
    chapters = widget.book.chapters.isNotEmpty
        ? widget.book.chapters
        : List.generate(
            10,
            (index) =>
                "Chapter ${index + 1}\n\nThis is demo content for the reader system.\n\n"
                "Scroll or swipe to read the next chapter.",
          );

    if (!widget.isLocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final readerProvider =
            Provider.of<ReaderProvider>(context, listen: false);

        readerProvider.loadBook(
          bookId: widget.book.id,
          totalChapters: chapters.length,
          lastReadChapter: widget.book.lastReadChapter,
        );

        /// Jump to last read chapter
        readerProvider.pageController.jumpToPage(
          widget.book.lastReadChapter.clamp(0, chapters.length - 1),
        );
      });
    }
  }

  @override
  void dispose() {
    if (!widget.isLocked) {
      final readerProvider =
          Provider.of<ReaderProvider>(context, listen: false);

      readerProvider.saveProgress(widget.book.id);
    }

    super.dispose();
  }

  /// THEME HELPER
  (Color, Color) _resolveTheme(ReaderProvider provider) {
    switch (provider.themeMode) {
      case ReaderThemeMode.dark:
        return (Colors.black, Colors.white);

      case ReaderThemeMode.sepia:
        return (const Color(0xFFF4ECD8), Colors.brown.shade800);

      case ReaderThemeMode.light:
        return (Colors.white, Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderProvider>(
      builder: (context, readerProvider, child) {
        final (bgColor, textColor) = _resolveTheme(readerProvider);

        final location = readerProvider.currentChapter.toString();

        return Scaffold(
          backgroundColor: bgColor,

          /// APP BAR
          appBar: readerProvider.showControls
              ? AppBar(
                  backgroundColor: bgColor,
                  elevation: 0,
                  iconTheme: IconThemeData(color: textColor),
                  title: Text(
                    widget.book.title,
                    style: TextStyle(color: textColor),
                  ),
                  actions: [
                    /// BOOKMARK
                    IconButton(
                      icon: Icon(
                        readerProvider.isBookmarked(location)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: textColor,
                      ),
                      onPressed: widget.isLocked
                          ? null
                          : () async {
                              await readerProvider.toggleBookmark(location);

                              final bookmarked =
                                  readerProvider.isBookmarked(location);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    bookmarked
                                        ? "Bookmark added"
                                        : "Bookmark removed",
                                  ),
                                  duration:
                                      const Duration(milliseconds: 900),
                                ),
                              );
                            },
                    ),

                    /// THEME
                    PopupMenuButton<ReaderThemeMode>(
                      icon: Icon(Icons.color_lens, color: textColor),
                      onSelected: readerProvider.changeTheme,
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: ReaderThemeMode.light,
                          child: Text("Light"),
                        ),
                        PopupMenuItem(
                          value: ReaderThemeMode.dark,
                          child: Text("Dark"),
                        ),
                        PopupMenuItem(
                          value: ReaderThemeMode.sepia,
                          child: Text("Sepia"),
                        ),
                      ],
                    ),

                    /// FONT
                    PopupMenuButton<String>(
                      icon: Icon(Icons.text_fields, color: textColor),
                      onSelected: (value) {
                        if (value == "inc") {
                          readerProvider.increaseFont();
                        } else {
                          readerProvider.decreaseFont();
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: "inc",
                          child: Text("Increase Font"),
                        ),
                        PopupMenuItem(
                          value: "dec",
                          child: Text("Decrease Font"),
                        ),
                      ],
                    ),
                  ],
                )
              : null,

          /// BODY
          body: widget.isLocked
              ? _lockedView(context)
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: readerProvider.toggleControls,
                  child: Column(
                    children: [
                      /// PROGRESS BAR
                      if (readerProvider.showControls)
                        LinearProgressIndicator(
                          value: readerProvider.currentBookProgress / 100,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.deepPurple,
                          minHeight: 3,
                        ),

                      /// CHAPTER PAGE VIEW
                      Expanded(
                        child: PageView.builder(
                          controller: readerProvider.pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: chapters.length,
                          onPageChanged: readerProvider.setChapter,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 30,
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Text(
                                  chapters[index],
                                  style: TextStyle(
                                    fontSize: readerProvider.fontSize,
                                    height: 1.7,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

          /// BOTTOM CONTROLS
          bottomNavigationBar: widget.isLocked
              ? null
              : readerProvider.showControls
                  ? Container(
                      color: bgColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          /// PREVIOUS
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                color: textColor),
                            onPressed:
                                readerProvider.goToPreviousChapter,
                          ),

                          /// TTS
                          IconButton(
                            icon: Icon(
                              readerProvider.isSpeaking
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              color: textColor,
                            ),
                            onPressed: () {
                              readerProvider.setSpeaking(
                                  !readerProvider.isSpeaking);
                            },
                          ),

                          /// NEXT
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios,
                                color: textColor),
                            onPressed: readerProvider.nextChapter,
                          ),
                        ],
                      ),
                    )
                  : null,
        );
      },
    );
  }

  /// LOCKED VIEW
  Widget _lockedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 70, color: Colors.deepPurple),
            const SizedBox(height: 20),
            const Text(
              "Premium Content",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Subscribe to unlock this book",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text("Subscribe Now"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const ReaderSubscriptionScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
