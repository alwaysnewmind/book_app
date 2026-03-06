import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_app/features/home/mainicon/premium icon/services/premium_repository.dart';
import 'premium_state.dart';

class PremiumController extends StateNotifier<PremiumState> {
  final PremiumRepository repository;

  PremiumController(this.repository) : super(const PremiumState());

  Future<void> startTrial() async {
    try {
      state = state.copyWith(
        isProcessing: true,
        status: PremiumStatus.loading,
      );

      await repository.startFreeTrial();

      state = state.copyWith(
        isProcessing: false,
        status: PremiumStatus.success,
        message: "Trial activated successfully 🎉",
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        status: PremiumStatus.error,
        message: e.toString(),
      );
    }
  }

  Future<void> restorePurchase() async {
    try {
      state = state.copyWith(isProcessing: true);

      await repository.restorePurchase();

      state = state.copyWith(
        isProcessing: false,
        status: PremiumStatus.success,
        message: "Purchase restored successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        status: PremiumStatus.error,
        message: e.toString(),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }
}