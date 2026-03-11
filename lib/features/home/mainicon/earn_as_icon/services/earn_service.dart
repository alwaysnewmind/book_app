import 'package:book_app/features/home/mainicon/earn_as_icon/models/earn_model.dart' show EarnModel;



class EarnService {

  EarnModel loadEarnings() {
    return const EarnModel(
      readerCoins: 0,
      readerCash: 0,
      writerEarnings: 0,
      totalReads: 0,
    );
  }

  /// Reader coins calculation
  int calculateCoinsFromPages(int pages) {
    int coins = pages;

    if (pages >= 10) {
      coins += 5;
    }

    return coins;
  }

  /// Coin → Cash conversion
  double convertCoinsToCash(int coins) {
    return coins / 100;
  }

  /// Writer earnings from chapter reads
  double calculateWriterChapterEarning(int chaptersRead) {
    return chaptersRead * 0.10;
  }

  /// Writer earnings from completed books
  double calculateWriterBookEarning(int booksCompleted) {
    return booksCompleted * 2;
  }
}