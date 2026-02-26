import 'package:book_app/features/reader/controller/reader_controller.dart';
import 'package:book_app/features/reader/data/dummy_reader_data.dart';
import 'package:book_app/features/reader/screens/pdf_reader_screen.dart';
import 'package:book_app/features/reader/screens/reader_screen.dart';
import 'package:book_app/features/reader/widgets/continue_reading_list.dart';
import 'package:book_app/features/reader/widgets/reader_analytics_widget.dart';
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart';
import 'package:book_app/features/reader/widgets/reader_section.dart';
import 'package:flutter/material.dart';
import '../widgets/reader_header.dart';
import '../widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';

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
  }

  @override
  void dispose() {
    _readerController.dispose();
    super.dispose();
  }

  void _openPdfReader(ReaderBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfReaderScreen(book: book),
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

  void _openTask(ReadingTask task) {
    final fallbackBook = DummyReaderData.continueReading.isNotEmpty
        ? DummyReaderData.continueReading.first
        : DummyReaderData.featuredBooks.first;
    _openPdfReader(fallbackBook);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ReaderHeader(),
              const SizedBox(height: 28),
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
              ReaderAnalyticsWidget(onTap: _openAnalytics),
              const SizedBox(height: _sectionSpacing),
              const ReaderSectionTitle(title: 'Continue Reading'),
              ContinueReadingSlider(
                books: DummyReaderData.continueReading,
                onBookTap: _openPdfReader,
              ),
              const SizedBox(height: _sectionSpacing),
              const ReaderSectionTitle(title: 'Featured Books'),
              ContinueReadingSlider(
                books: DummyReaderData.featuredBooks,
                onBookTap: _openPdfReader,
              ),
              const SizedBox(height: _sectionSpacing),
              const ReaderSectionTitle(title: 'Recommended For You'),
              RecommendedBooksGrid(onBookTap: _openPdfReader),
              const SizedBox(height: _sectionSpacing),
              const ReaderSectionTitle(title: 'Reading Tasks'),
              ReadingTaskSection(onTaskTap: _openTask),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
