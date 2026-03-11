import 'package:flutter/material.dart';
import 'package:book_app/features/premium/presentation/premium_state.dart'
    show PremiumState, PremiumStatus;
import 'package:book_app/features/home/mainicon/premium_icon/services/premium_repository.dart';

class PremiumController extends ChangeNotifier {
  final PremiumRepository repository;

  PremiumState _state = const PremiumState();

  PremiumState get state => _state;

  bool get isProcessing => _state.isProcessing;
  String? get message => _state.message;
  PremiumStatus get status => _state.status;

  PremiumController(this.repository);

  Future<void> startTrial() async {
    try {
      _state = _state.copyWith(
        isProcessing: true,
        status: PremiumStatus.loading,
      );
      notifyListeners();

      await repository.startFreeTrial();

      _state = _state.copyWith(
        isProcessing: false,
        status: PremiumStatus.success,
        message: "Trial activated successfully 🎉",
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isProcessing: false,
        status: PremiumStatus.error,
        message: e.toString(),
      );
      notifyListeners();
    }
  }

  Future<void> restorePurchase() async {
    try {
      _state = _state.copyWith(isProcessing: true);
      notifyListeners();

      await repository.restorePurchase();

      _state = _state.copyWith(
        isProcessing: false,
        status: PremiumStatus.success,
        message: "Purchase restored successfully",
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        isProcessing: false,
        status: PremiumStatus.error,
        message: e.toString(),
      );
      notifyListeners();
    }
  }

  void clearMessage() {
    _state = _state.copyWith(message: null);
    notifyListeners();
  }
}