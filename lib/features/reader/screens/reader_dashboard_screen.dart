import 'package:book_app/features/reader/widgets/continue_reading_list.dart' show ContinueReadingSlider;
import 'package:book_app/features/reader/widgets/reader_recommended_books_grid.dart' show RecommendedBooksGrid;
import 'package:book_app/features/reader/widgets/reader_section.dart' show ReaderSectionTitle;
import 'package:flutter/material.dart';

import '../widgets/reader_header.dart';
import '../widgets/reader_stats_grid.dart';
import 'package:book_app/features/reader/widgets/reading_task_section.dart';

class ReaderDashboardScreen extends StatelessWidget {
  const ReaderDashboardScreen({super.key});

  static const double _horizontalPadding = 16;
  static const double _sectionSpacing = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /// Header
              ReaderHeader(),

              SizedBox(height: 20),

              /// Stats
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: ReaderStatsGrid(),
              ),

              SizedBox(height: _sectionSpacing),

              /// Continue Reading
              ReaderSectionTitle(title: "Continue Reading"),
              ContinueReadingSlider(),

              SizedBox(height: _sectionSpacing),

              /// Featured Books
              ReaderSectionTitle(title: "Featured Books"),
              ContinueReadingSlider(),

              SizedBox(height: _sectionSpacing),

              /// Recommended
              ReaderSectionTitle(title: "Recommended For You"),
              RecommendedBooksGrid(),

              SizedBox(height: _sectionSpacing),

              /// Reading Tasks
              ReaderSectionTitle(title: "Reading Tasks"),
              ReadingTaskSection(),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}