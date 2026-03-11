import 'package:book_app/features/home/mainicon/earn_as_icon/models/earn_model.dart' show EarnModel;
import 'package:flutter/material.dart';
import '../services/earn_service.dart';

class EarnProvider extends ChangeNotifier {

  final EarnService _service = EarnService();

  EarnModel _earn = const EarnModel(
    readerCoins: 0,
    readerCash: 0,
    writerEarnings: 0,
    totalReads: 0,
  );

  EarnModel get earn => _earn;

  void load() {
    _earn = _service.loadEarnings();
    notifyListeners();
  }

  /// Reader earning
  void addReaderCoins(int pagesRead) {

    final coins = _service.calculateCoinsFromPages(pagesRead);

    final totalCoins = _earn.readerCoins + coins;

    _earn = _earn.copyWith(
      readerCoins: totalCoins,
      readerCash: _service.convertCoinsToCash(totalCoins),
    );

    notifyListeners();
  }

  /// Writer earning
  void addWriterChapterReads(int chapters) {

    final earn = _service.calculateWriterChapterEarning(chapters);

    _earn = _earn.copyWith(
      writerEarnings: _earn.writerEarnings + earn,
    );

    notifyListeners();
  }

}