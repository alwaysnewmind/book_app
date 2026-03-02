import 'package:in_app_purchase/in_app_purchase.dart';

import 'entities/subscription_info.dart';

abstract class PremiumRepository {
  Future<List<ProductDetails>> fetchProducts();
  Future<void> buySubscription(ProductDetails product);
  Stream<List<PurchaseDetails>> watchPurchases();
  Future<void> restorePurchases();
  Future<SubscriptionInfo> verifyAndPersistPurchase({
    required String userId,
    required PurchaseDetails purchase,
  });
  Future<SubscriptionInfo> readPersistedSubscription();
  Future<SubscriptionInfo> refreshSubscriptionStatus();
}
