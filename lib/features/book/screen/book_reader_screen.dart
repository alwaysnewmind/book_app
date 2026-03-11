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

    chapters = widget.book.chapters.isNotEmpty
        ? widget.book.chapters
        : List.generate(
            10,
            (index) => "Chapter ${index + 1}\n\nThis is demo content...",
          );

    final readerProvider =
        Provider.of<ReaderProvider>(context, listen: false);

    readerProvider.loadBook(
      bookId: widget.book.id,
      totalChapters: chapters.length,
      lastReadChapter: widget.book.lastReadChapter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderProvider>(
      builder: (context, readerProvider, child) {

        /// Theme
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

        /// Convert chapter index → bookmark location
        String location = readerProvider.currentChapter.toString();

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
                      onPressed: () async {

                        await readerProvider.toggleBookmark(location);

                        bool bookmarked =
                            readerProvider.isBookmarked(location);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              bookmarked
                                  ? "Bookmarked"
                                  : "Removed Bookmark",
                            ),
                            duration:
                                const Duration(milliseconds: 800),
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

          /// BODY
          body: GestureDetector(
            onTap: readerProvider.toggleControls,
            child: Column(
              children: [

                /// Progress
                if (readerProvider.showControls)
                  LinearProgressIndicator(
                    value: readerProvider.progress / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.deepPurple,
                    minHeight: 3,
                  ),

                /// PageView
                Expanded(
                  child: PageView.builder(
                    controller: readerProvider.pageController,
                    onPageChanged: (index) {
                      readerProvider.setChapter(index);
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

          /// BOTTOM CONTROLS
          bottomNavigationBar: readerProvider.showControls
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

          /// LOCK CHECK
          floatingActionButton: widget.isLocked
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.deepPurple,
                  label: const Text("Subscribe to Read"),
                  icon: const Icon(Icons.lock_open),
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
              : null,
        );
      },
    );
  }
}