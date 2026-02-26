import 'package:book_app/features/reader/widgets/continue_reading_list.dart' show ContinueReadingSlider;
import 'package:book_app/features/reader/data/dummy_reader_data.dart' show DummyReaderData, ReaderBook;
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart' show RecommendedBooksGrid;
import 'package:book_app/features/reader/widgets/reader_section.dart' show ReaderSectionTitle;
import 'package:book_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../widgets/reader_header.dart';
import '../widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';

class ReaderDashboardScreen extends StatelessWidget {
  const ReaderDashboardScreen({super.key});

  static const double _horizontalPadding = 16;
  static const double _sectionSpacing = 28;

  void _openPdfReader(BuildContext context, ReaderBook book) {
    Navigator.pushNamed(
      context,
      AppRoutes.pdfReader,
      arguments: book,
    );
  }

  void _openReaderScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.readerScreen,
      arguments: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /// Header
              ReaderHeader(),

                const SizedBox(height: 28),

              /// Stats
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: ReaderStatsGrid(
                  onTap: () => _openReaderScreen(context),
                ),
              ),

                const SizedBox(height: _sectionSpacing),

              /// Continue Reading
              ReaderSectionTitle(title: "Continue Reading"),
              ContinueReadingSlider(
                books: DummyReaderData.continueReading,
                onBookTap: (book) => _openPdfReader(context, book),
              ),

                const SizedBox(height: _sectionSpacing),

              /// Featured Books
              ReaderSectionTitle(title: "Featured Books"),
              ContinueReadingSlider(
                books: DummyReaderData.featuredBooks,
                onBookTap: (book) => _openPdfReader(context, book),
              ),

                const SizedBox(height: _sectionSpacing),

              /// Recommended
              ReaderSectionTitle(title: "Recommended For You"),
              RecommendedBooksGrid(
                onBookTap: (book) => _openPdfReader(context, book),
              ),

              SizedBox(height: _sectionSpacing),

              /// Reading Tasks
              ReaderSectionTitle(title: "Reading Tasks"),
              ReadingTaskSection(
                onTaskTap: (_) => _openReaderScreen(context),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
