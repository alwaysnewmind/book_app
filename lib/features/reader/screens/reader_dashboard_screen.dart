import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:book_app/features/reader/screens/reader_screen.dart';
import 'package:book_app/features/reader/widgets/continue_reading_list.dart';
import 'package:book_app/features/reader/widgets/reader_analytics_widget.dart';
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart';
import 'package:book_app/features/reader/widgets/reader_section.dart';
import 'package:book_app/features/reader/widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';
import 'package:book_app/providers/auth_provider.dart';
import 'package:book_app/providers/reader_studio_provider.dart';
import 'package:book_app/shared/widgets/app_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/reader_header.dart';

class ReaderDashboardScreen extends StatefulWidget {
  const ReaderDashboardScreen({super.key});

  @override
  State<ReaderDashboardScreen> createState() => _ReaderDashboardScreenState();
}

class _ReaderDashboardScreenState extends State<ReaderDashboardScreen> {
  static const double _horizontalPadding = 16;
  static const double _sectionSpacing = 28;

  final ReaderController _readerController = ReaderController();

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

    await studioProvider.loadReaderStudioData(userId: authProvider.currentUser?.uid);

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
    final theme = Theme.of(context);

    return Consumer<ReaderStudioProvider>(
      builder: (context, studioProvider, _) {
        final continueReadingBooks = studioProvider.getContinueReading();
        final recentlyReadBooks = studioProvider.getRecentlyRead();
        final favoriteBooks = studioProvider.getQuickAccessFavorites();
        final featuredBooks = favoriteBooks.isNotEmpty ? favoriteBooks : recentlyReadBooks;
        final recommendedBooks = studioProvider.getRecommendedBooks();

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ReaderHeader(),
                    const SizedBox(height: 28),

                    /// Stats
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
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

                    const SizedBox(height: _sectionSpacing),

                    /// Analytics
                    ReaderAnalyticsWidget(onTap: _openAnalytics),

                    const SizedBox(height: _sectionSpacing),

                    if (studioProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (studioProvider.allBooks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Center(child: Text('No Reader Studio data found.')),
                      )
                    else ...[
                      /// Continue Reading
                      const ReaderSectionTitle(title: 'Continue Reading'),
                      continueReadingBooks.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text('No books in progress yet.'),
                            )
                          : ContinueReadingSlider(
                              books: continueReadingBooks,
                              onBookTap: _openPdfReader,
                              onBookLongPress: _toggleBookmark,
                            ),

                      const SizedBox(height: _sectionSpacing),

                      /// Featured Books
                      const ReaderSectionTitle(title: 'Featured Books'),
                      featuredBooks.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text('No recently read books yet.'),
                            )
                          : ContinueReadingSlider(
                              books: featuredBooks,
                              onBookTap: _openPdfReader,
                              onBookLongPress: _toggleBookmark,
                            ),

                      const SizedBox(height: _sectionSpacing),

                      /// Recommended
                      const ReaderSectionTitle(title: 'Recommended For You'),
                      recommendedBooks.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text('No recommendations available.'),
                            )
                          : RecommendedBooksGrid(
                              books: recommendedBooks,
                              onBookTap: _openPdfReader,
                              onBookLongPress: _toggleBookmark,
                            ),

                      const SizedBox(height: _sectionSpacing),
                    ],

                    /// Reading Tasks
                    const ReaderSectionTitle(title: 'Reading Tasks'),
                    ReadingTaskSection(
                      onTaskTap: (_) => _openAnalytics(),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
