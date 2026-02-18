import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Library
import 'package:book_app/features/library/models/library_book.dart';

// Reader provider
import 'package:book_app/providers/reader_provider.dart';

// Subscription Screen
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

    // For demo purposes, you need to define chapters inside widget
    chapters = widget.book.toJson()['chapters'] != null
        ? List<String>.from(widget.book.toJson()['chapters'])
        : List.generate(10, (index) => "Chapter ${index + 1} content");

    final readerProvider =
        Provider.of<ReaderProvider>(context, listen: false);

    readerProvider.loadBook(
      bookId: widget.book.id,
      totalChapters: chapters.length,
      lastReadChapter:
          readerProvider.lastReadChapter, // use provider's stored value
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderProvider>(
      builder: (context, readerProvider, child) {
        /// ===============================
        /// THEME
        /// ===============================
        Color bgColor;
        Color textColor;

        switch (readerProvider.themeMode) {
          case ReaderThemeMode.dark:
            bgColor = Colors.black;
            textColor = Colors.white;
            break;
          case ReaderThemeMode.sepia:
            bgColor = const Color(0xFFF4ECD8);
            textColor = Colors.brown;
            break;
          default:
            bgColor = Colors.white;
            textColor = Colors.black;
        }

        return Scaffold(
          backgroundColor: bgColor,

          /// ===============================
          /// APP BAR
          /// ===============================
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
                    /// Bookmark
                    IconButton(
                      icon: Icon(
                        readerProvider.isBookmarked(
                                readerProvider.currentChapter)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: textColor,
                      ),
                      onPressed: () {
                        readerProvider.toggleBookmark();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(readerProvider.isBookmarked(
                                    readerProvider.currentChapter)
                                ? 'Bookmarked'
                                : 'Removed Bookmark'),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                    ),

                    /// Theme
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

                    /// Font
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
                          child: Text("Increase"),
                        ),
                        PopupMenuItem(
                          value: "dec",
                          child: Text("Decrease"),
                        ),
                      ],
                    ),
                  ],
                )
              : null,

          /// ===============================
          /// BODY
          /// ===============================
          body: GestureDetector(
            onTap: readerProvider.toggleControls,
            child: Column(
              children: [
                /// Progress Bar
                if (readerProvider.showControls)
                  LinearProgressIndicator(
                    value: readerProvider.progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.deepPurple,
                    minHeight: 3,
                  ),

                /// Chapter PageView
                Expanded(
                  child: PageView.builder(
                    controller: readerProvider.pageController,
                    onPageChanged: (index) {
                      readerProvider.setChapter(index);
                      // No setter on book.lastReadChapter, provider handles it
                    },
                    itemCount: chapters.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: SingleChildScrollView(
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

          /// ===============================
          /// BOTTOM CONTROLS
          /// ===============================
          bottomNavigationBar: readerProvider.showControls
              ? Container(
                  color: bgColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Previous
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: textColor),
                        onPressed: readerProvider.previousChapter,
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

                      /// Next
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: textColor),
                        onPressed: readerProvider.nextChapter,
                      ),
                    ],
                  ),
                )
              : null,

          /// ===============================
          /// LOCKED BOOK CHECK
          /// ===============================
          floatingActionButton: widget.isLocked
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.deepPurple,
                  label: const Text("Subscribe to Read"),
                  icon: const Icon(Icons.lock_open),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReaderSubscriptionScreen(),
                      ),
                    );
                  },
                )
              : null,
        );
      },
    );
  }
}
