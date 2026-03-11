class EarnModel {
  final int readerCoins;
  final double readerCash;

  final double writerEarnings;
  final int totalReads;

  const EarnModel({
    required this.readerCoins,
    required this.readerCash,
    required this.writerEarnings,
    required this.totalReads,
  });

  EarnModel copyWith({
    int? readerCoins,
    double? readerCash,
    double? writerEarnings,
    int? totalReads,
  }) {
    return EarnModel(
      readerCoins: readerCoins ?? this.readerCoins,
      readerCash: readerCash ?? this.readerCash,
      writerEarnings: writerEarnings ?? this.writerEarnings,
      totalReads: totalReads ?? this.totalReads,
    );
  }
}