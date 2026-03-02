import 'package:in_app_purchase/in_app_purchase.dart';

import 'entities/subscription_info.dart';
import 'premium_repository.dart';

class PurchaseSubscription {
  final PremiumRepository _repository;

  const PurchaseSubscription(this._repository);

  Future<List<ProductDetails>> fetchProducts() => _repository.fetchProducts();

  Future<void> buy(ProductDetails product) =>
      _repository.buySubscription(product);

  Stream<List<PurchaseDetails>> watchPurchases() =>
      _repository.watchPurchases();

  Future<void> restore() => _repository.restorePurchases();

  Future<SubscriptionInfo> verifyAndPersist({
    required String userId,
    required PurchaseDetails purchase,
  }) {
    return _repository.verifyAndPersistPurchase(
      userId: userId,
      purchase: purchase,
    );
  }

  Future<SubscriptionInfo> readPersistedSubscription() =>
      _repository.readPersistedSubscription();

  Future<SubscriptionInfo> refreshSubscriptionStatus() =>
      _repository.refreshSubscriptionStatus();
}
