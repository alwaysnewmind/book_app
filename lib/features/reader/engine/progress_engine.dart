

class ProgressEngine {

  /// =========================
  /// SCROLL BASED PROGRESS
  /// =========================

  double calculateScrollProgress({
    required double scroll,
    required double maxScroll,
  }) {
    if (maxScroll <= 0) return 0;

    final progress = (scroll / maxScroll) * 100;

    return progress.clamp(0, 100);
  }

  /// =========================
  /// PAGE BASED PROGRESS
  /// =========================

  double calculatePageProgress({
    required int currentPage,
    required int totalPages,
  }) {
    if (totalPages == 0) return 0;

    final progress = (currentPage / totalPages) * 100;

    return progress.clamp(0, 100);
  }

  /// =========================
  /// CHAPTER PROGRESS
  /// =========================

  double calculateChapterProgress({
    required int currentChapter,
    required int totalChapters,
  }) {
    if (totalChapters == 0) return 0;

    final progress = (currentChapter / totalChapters) * 100;

    return progress.clamp(0, 100);
  }

  /// =========================
  /// BOOK COMPLETION CHECK
  /// =========================

  bool isBookCompleted(double progress) {
    return progress >= 100;
  }

  /// =========================
  /// PAGES READ CALCULATOR
  /// =========================

  int calculatePagesRead({
    required double progress,
    required int totalPages,
  }) {
    return (progress / 100 * totalPages).round();
  }

  /// =========================
  /// READING SPEED
  /// pages per minute
  /// =========================

  double calculateReadingSpeed({
    required int pagesRead,
    required int minutes,
  }) {
    if (minutes == 0) return 0;

    return pagesRead / minutes;
  }

  /// =========================
  /// ESTIMATED TIME LEFT
  /// =========================

  int estimateRemainingMinutes({
    required int pagesLeft,
    required double pagesPerMinute,
  }) {
    if (pagesPerMinute == 0) return 0;

    return (pagesLeft / pagesPerMinute).ceil();
  }

  /// =========================
  /// READING PERCENT LABEL
  /// =========================

  String formatProgress(double progress) {
    return "${progress.toStringAsFixed(0)}%";
  }

  /// =========================
  /// BOOK STATUS
  /// =========================

  String getReadingStatus(double progress) {

    if (progress == 0) {
      return "Not Started";
    }

    if (progress < 25) {
      return "Just Started";
    }

    if (progress < 75) {
      return "In Progress";
    }

    if (progress < 100) {
      return "Almost Finished";
    }

    return "Completed";
  }

  /// Calculate reading progress (0 → 1)
  double calculateProgress(double scroll, double maxScroll) {

    if (maxScroll <= 0) return 0.0;

    final double safeSize =
        (scroll / maxScroll).clamp(0.0, 1.0).toDouble();

    return safeSize;
  }
}

  Object? calculateProgress(double scroll, double maxScroll) {
    return null;
  }

