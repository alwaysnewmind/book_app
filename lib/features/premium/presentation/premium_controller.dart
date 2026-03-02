import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/premium_repository_impl.dart';
import '../domain/purchase_subscription.dart';
import 'premium_state.dart';

class PremiumController extends StateNotifier<PremiumState> {
  final PurchaseSubscription _purchaseSubscription;
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<List<PurchaseDetails>>? _purchaseStreamSubscription;
  bool _disposed = false;

  PremiumController({
    required PurchaseSubscription purchaseSubscription,
    required FirebaseAuth firebaseAuth,
  })  : _purchaseSubscription = purchaseSubscription,
        _firebaseAuth = firebaseAuth,
        super(PremiumState.initial()) {
    _listenForPurchases();
    refreshOnLaunch();
  }

  Future<void> refreshOnLaunch() async {
    try {
      final info = await _purchaseSubscription.refreshSubscriptionStatus();
      if (_disposed) return;

      state = state.copyWith(
        status: info.isPremium
            ? PremiumStatus.premiumActive
            : PremiumStatus.premiumExpired,
        isPremium: info.isPremium,
        expiryDate: info.expiryDate,
        planType: info.planType,
        clearMessage: true,
      );
    } catch (_) {
      if (_disposed) return;
      state = state.copyWith(
        status: PremiumStatus.error,
        message: 'Failed to refresh premium state.',
        isProcessing: false,
      );
    }
  }

  Future<void> startTrial() async {
    if (state.isProcessing) return;

    state = state.copyWith(
      status: PremiumStatus.loading,
      isProcessing: true,
      clearMessage: true,
    );

    try {
      final products = await _purchaseSubscription.fetchProducts();
      final product = products.firstWhere(
        (p) => p.id == PremiumRepositoryImpl.monthlyProductId,
        orElse: () => products.first,
      );

      await _purchaseSubscription.buy(product);
    } catch (e) {
      _setError(_humanizeError(e));
    }
  }

  Future<void> restorePurchase() async {
    if (state.isProcessing) return;

    state = state.copyWith(
      status: PremiumStatus.loading,
      isProcessing: true,
      clearMessage: true,
    );

    try {
      await _purchaseSubscription.restore();
    } catch (e) {
      _setError('Restore failed: ${_humanizeError(e)}');
    }
  }

  void clearMessage() {
    state = state.copyWith(clearMessage: true);
  }

  void _listenForPurchases() {
    _purchaseStreamSubscription =
        _purchaseSubscription.watchPurchases().listen(_handlePurchases);
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    if (purchases.isEmpty) {
      if (state.isProcessing) {
        state = state.copyWith(isProcessing: false);
      }
      return;
    }

    for (final purchase in purchases) {
      if (_disposed) return;

      if (purchase.status == PurchaseStatus.pending) {
        state = state.copyWith(
          status: PremiumStatus.loading,
          isProcessing: true,
        );
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        _setError(purchase.error?.message ?? 'Purchase failed.');
      } else if (purchase.status == PurchaseStatus.canceled) {
        _setError('Purchase cancelled by user.');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _processVerifiedPurchase(purchase);
      }

      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  Future<void> _processVerifiedPurchase(PurchaseDetails purchase) async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('Please sign in to activate premium.');
      }

      final info = await _purchaseSubscription.verifyAndPersist(
        userId: userId,
        purchase: purchase,
      );

      final expired = info.expiryDate == null || info.isExpired;
      if (expired) {
        state = state.copyWith(
          status: PremiumStatus.premiumExpired,
          isProcessing: false,
          isPremium: false,
          clearExpiry: true,
          clearPlan: true,
          message: 'Subscription expired.',
        );
      } else {
        state = state.copyWith(
          status: PremiumStatus.success,
          isProcessing: false,
          isPremium: true,
          expiryDate: info.expiryDate,
          planType: info.planType,
          message: 'Premium unlocked successfully!',
        );
      }
    } catch (e) {
      _setError(_humanizeError(e));
    }
  }

  void _setError(String error) {
    state = state.copyWith(
      status: PremiumStatus.error,
      isProcessing: false,
      message: error,
    );
  }

  String _humanizeError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('network')) {
      return 'Network unavailable. Please try again.';
    }
    if (message.contains('store is unavailable')) {
      return 'Store not available on this device.';
    }
    if (message.contains('already own') || message.contains('duplicate')) {
      return 'You already own this subscription. Try restore purchase.';
    }
    if (message.contains('cancel')) {
      return 'Purchase cancelled by user.';
    }
    if (message.contains('validation failed') || message.contains('invalid')) {
      return 'Invalid receipt. Premium could not be activated.';
    }

    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  void dispose() {
    _disposed = true;
    _purchaseStreamSubscription?.cancel();
    super.dispose();
  }
}
