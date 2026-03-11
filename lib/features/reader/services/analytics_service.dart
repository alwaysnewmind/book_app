class ReaderAnalyticsService {

  int booksCompleted = 0;
  int pagesRead = 0;

  void addPages(int pages) {
    pagesRead += pages;
  }

  void completeBook() {
    booksCompleted++;
  }
}