import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:book_app/features/reader/screens/reader_screen.dart';
import 'package:book_app/features/reader/widgets/continue_reading_list.dart';
import 'package:book_app/features/reader/widgets/reader_analytics_widget.dart';
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart';
import 'package:book_app/features/reader/widgets/reader_section.dart';
import 'package:book_app/features/reader/widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';
import 'package:book_app/features/auth/provider/auth_provider.dart';
import 'package:book_app/features/reader/provider/reader_studio_provider.dart';
import 'package:book_app/shared/widgets/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/reader_header.dart';

class ReaderDashboardScreen extends StatefulWidget {
  const ReaderDashboardScreen({super.key});

  @override
  State<ReaderDashboardScreen> createState() =>
      _ReaderDashboardScreenState();
}

class _ReaderDashboardScreenState extends State<ReaderDashboardScreen> {
  static const double _horizontalPadding = 20;
  static const double _sectionSpacing = 36;

  final ReaderController _readerController = ReaderController();

  // 🌌 LUXURY COLOR SYSTEM (UPDATED)
  static const Color bgPrimary = Color(0xFF1F1533);
  static const Color bgMid = Color(0xFF2A1E47);
  static const Color bgEnd = Color(0xFF140F26);

  static const Color gold = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFC8E8);
  static const Color textMuted = Color(0xFF9F96C8);

  // 🔥 UPDATED CARD COLORS (No More White)
  static const Color cardFill = Color(0xFF251A3F);
  static const Color cardSoft = Color(0xFF2E224F); // NEW
  static const Color borderInactive = Color(0xFF3A2D5C);

  @override
  void initState() {
    super.initState();
    _readerController.init();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final studioProvider = context.read<ReaderStudioProvider>();

    if (!authProvider.isLoggedIn) {
      await showAppPopup(
        context: context,
        title: 'Login Required',
        message: 'Login to access Reader Studio features',
        buttonText: 'OK',
      );
      return;
    }

    await studioProvider.loadReaderStudioData(
        userId: authProvider.currentUser?.uid);

    final error = studioProvider.errorMessage;
    if (error != null && mounted) {
      await showAppPopup(
        context: context,
        title: 'Something went wrong',
        message: error,
        buttonText: 'Close',
      );
    }
  }

  @override
  void dispose() {
    _readerController.dispose();
    super.dispose();
  }

  void _openPdfReader(ReaderBookModel book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReaderScreen(isLocked: false),
      ),
    );
  }

  void _openAnalytics() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReaderScreen(isLocked: false),
      ),
    );
  }

  Future<void> _toggleBookmark(ReaderBookModel book) async {
    try {
      await context.read<ReaderStudioProvider>().toggleBookmark(
            bookId: book.id,
            userId: context.read<AuthProvider>().currentUser?.uid,
          );
    } catch (_) {
      if (!mounted) return;
      await showAppPopup(
        context: context,
        title: 'Action failed',
        message: 'Unable to update bookmark right now.',
        buttonText: 'Close',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderStudioProvider>(
      builder: (context, studioProvider, _) {
        final continueReadingBooks = studioProvider.getContinueReading();
        final recentlyReadBooks = studioProvider.getRecentlyRead();
        final favoriteBooks = studioProvider.getQuickAccessFavorites();
        final featuredBooks =
            favoriteBooks.isNotEmpty ? favoriteBooks : recentlyReadBooks;
        final recommendedBooks =
            studioProvider.getRecommendedBooks();

        return Scaffold(
          backgroundColor: bgPrimary,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [bgPrimary, bgMid, bgEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                color: gold,
                backgroundColor: cardFill,
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔥 HEADER (Make sure ReaderHeader uses dark grey)
                      const ReaderHeader(),

                      const SizedBox(height: 42),

                      /// 🔥 STATS CARD (Dark Soft Background)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: _horizontalPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardSoft,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: borderInactive),
                            boxShadow: [
                              BoxShadow(
                                color: goldGlow.withOpacity(0.15),
                                blurRadius: 25,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(24),
                          child: AnimatedBuilder(
                            animation: _readerController,
                            builder: (context, _) {
                              return ReaderStatsGrid(
                                controller: _readerController,
                                onTap: _openAnalytics,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: _sectionSpacing),

                      /// 🔥 ANALYTICS CARD
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: _horizontalPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardSoft,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: borderInactive),
                          ),
                          padding: const EdgeInsets.all(22),
                          child: ReaderAnalyticsWidget(
                            onTap: _openAnalytics,
                          ),
                        ),
                      ),

                      const SizedBox(height: _sectionSpacing + 6),

                      if (studioProvider.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: gold,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      else if (studioProvider.allBooks.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Center(
                            child: Text(
                              'No Reader Studio data found.',
                              style: TextStyle(
                                color: textMuted,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        )
                      else ...[

                        const ReaderSectionTitle(title: 'Continue Reading'),
                        ContinueReadingSlider(
                          books: continueReadingBooks,
                          onBookTap: _openPdfReader,
                          onBookLongPress: _toggleBookmark,
                        ),

                        const SizedBox(height: _sectionSpacing),

                        const ReaderSectionTitle(title: 'Featured Books'),
                        ContinueReadingSlider(
                          books: featuredBooks,
                          onBookTap: _openPdfReader,
                          onBookLongPress: _toggleBookmark,
                        ),

                        const SizedBox(height: _sectionSpacing),

                        const ReaderSectionTitle(title: 'Recommended For You'),
                        RecommendedBooksGrid(
                          books: recommendedBooks,
                          onBookTap: _openPdfReader,
                          onBookLongPress: _toggleBookmark,
                        ),

                        const SizedBox(height: _sectionSpacing),
                      ],

                      const ReaderSectionTitle(title: 'Reading Tasks'),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: _horizontalPadding),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardSoft,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: borderInactive),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: ReadingTaskSection(
                            onTaskTap: (_) => _openAnalytics(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}