import 'dart:async';
import '../models/earn_model.dart';

/// Mock API or Firestore service
class EarnService {
  /// Fetch current earnings (simulate API)
  Future<EarnModel> fetchEarnings() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network
    // Replace with real API/Firestore fetch
    return const EarnModel(
      readerCoins: 120,
      readerCash: 1.2,
      writerEarnings: 5.0,
      totalReads: 20,
    );
  }

  /// Update reader coins
  Future<EarnModel> addReaderCoins(EarnModel current, int pagesRead) async {
    if (pagesRead < 0) throw Exception('pagesRead cannot be negative');

    final coins = calculateCoinsFromPages(pagesRead);
    final totalCoins = current.readerCoins + coins;

    final updated = current.copyWith(
      readerCoins: totalCoins,
      readerCash: convertCoinsToCash(totalCoins),
      totalReads: current.totalReads + pagesRead,
    );

    await Future.delayed(const Duration(milliseconds: 200)); // simulate save
    return updated;
  }

  /// Update writer earnings
  Future<EarnModel> addWriterChapterReads(EarnModel current, int chapters) async {
    if (chapters < 0) throw Exception('chapters cannot be negative');

    final earn = calculateWriterChapterEarning(chapters);

    final updated = current.copyWith(
      writerEarnings: current.writerEarnings + earn,
    );

    await Future.delayed(const Duration(milliseconds: 200)); // simulate save
    return updated;
  }

  /// --- Business logic ---
  int calculateCoinsFromPages(int pages) {
    int coins = pages;
    if (pages >= 10) coins += 5;
    return coins;
  }

  double convertCoinsToCash(int coins) => coins / 100;

  double calculateWriterChapterEarning(int chapters) => chapters * 0.10;
}