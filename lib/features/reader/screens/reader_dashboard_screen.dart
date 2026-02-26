import 'package:book_app/features/reader/screens/pdf_reader_screen.dart' show PdfReaderScreen;
import 'package:book_app/features/reader/screens/reader_screen.dart';
import 'package:book_app/features/reader/widgets/continue_reading_list.dart'
    show ContinueReadingSlider;
import 'package:book_app/features/reader/data/dummy_reader_data.dart'
    show DummyReaderData, ReaderBook;
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart'
    show RecommendedBooksGrid;
import 'package:book_app/features/reader/widgets/reader_section.dart'
    show ReaderSectionTitle;
import 'package:book_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../widgets/reader_header.dart';
import '../widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';

class ReaderDashboardScreen extends StatelessWidget {
  const ReaderDashboardScreen({super.key});

  static const double _horizontalPadding = 20;
  static const double _sectionSpacing = 32;

  /// 🎨 LUXURY COLORS (STRICT SYSTEM)
  static const Color primaryBg = Color(0xFF1F1533);
  static const Color gradientMid = Color(0xFF2A1E47);
  static const Color gradientDark = Color(0xFF140F26);

  static const Color goldPrimary = Color(0xFFF5C84C);
  static const Color goldGlow = Color(0xFFFFD76A);

  static const Color cardFill = Color(0xFF251A3F);
  static const Color borderColor = Color(0xFF3A2D5C);

  static const Color headingText = Colors.white;
  static const Color secondaryText = Color(0xFFCFC8E8);

  void _openPdfReader(BuildContext context, ReaderBook book) {
    Navigator.pushNamed(
      context,
      AppRoutes.PdfReaderScreen,
      arguments: book,
    );
  }

  void _openReaderScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.ReaderScreen,
      arguments: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryBg,
              gradientMid,
              gradientDark,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                /// Header
                const ReaderHeader(),

                const SizedBox(height: 28),

                /// Stats
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: goldGlow.withOpacity(0.10),
                          blurRadius: 25,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ReaderStatsGrid(
                      onTap: () => _openReaderScreen(context),
                    ),
                  ),
                ),

                const SizedBox(height: _sectionSpacing),

                /// Continue Reading
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: ReaderSectionTitle(
                    title: "Continue Reading",
                  ),
                ),
                const SizedBox(height: 16),
                ContinueReadingSlider(
                  books: DummyReaderData.continueReading,
                  onBookTap: (book) =>
                      _openPdfReader(context, book),
                ),

                const SizedBox(height: _sectionSpacing),

                /// Featured Books
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: ReaderSectionTitle(
                    title: "Featured Books",
                  ),
                ),
                const SizedBox(height: 16),
                ContinueReadingSlider(
                  books: DummyReaderData.featuredBooks,
                  onBookTap: (book) =>
                      _openPdfReader(context, book),
                ),

                const SizedBox(height: _sectionSpacing),

                /// Recommended
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: ReaderSectionTitle(
                    title: "Recommended For You",
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                    ),
                    child: RecommendedBooksGrid(
                      onBookTap: (book) =>
                          _openPdfReader(context, book),
                    ),
                  ),
                ),

                const SizedBox(height: _sectionSpacing),

                /// Reading Tasks
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: ReaderSectionTitle(
                    title: "Reading Tasks",
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardFill,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor),
                    ),
                    child: ReadingTaskSection(
                      onTaskTap: (_) =>
                          _openReaderScreen(context),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}