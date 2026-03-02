import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/subscription_info.dart';
import '../domain/premium_repository.dart';
import 'premium_remote_datasource.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  static const String monthlyProductId = 'premium_monthly_199';
  static const String yearlyProductId = 'premium_yearly_1499';
  static const Set<String> _productIds = {monthlyProductId, yearlyProductId};

  static const _isPremiumKey = 'premium_is_active';
  static const _expiryDateKey = 'premium_expiry_date';
  static const _planTypeKey = 'premium_plan_type';

  final InAppPurchase _inAppPurchase;
  final PremiumRemoteDataSource _remoteDataSource;
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;

  PremiumRepositoryImpl({
    required InAppPurchase inAppPurchase,
    required PremiumRemoteDataSource remoteDataSource,
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  })  : _inAppPurchase = inAppPurchase,
        _remoteDataSource = remoteDataSource,
        _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage;

  @override
  Future<List<ProductDetails>> fetchProducts() async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('Store is unavailable right now. Please try again later.');
    }

    final response = await _inAppPurchase.queryProductDetails(_productIds);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    if (response.productDetails.isEmpty) {
      throw Exception('No subscription plans were found in the store.');
    }

    return response.productDetails;
  }

  @override
  Future<void> buySubscription(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    final started = await _inAppPurchase.buyNonConsumable(
      purchaseParam: purchaseParam,
    );

    if (!started) {
      throw Exception('Unable to start purchase flow.');
    }
  }

  @override
  Stream<List<PurchaseDetails>> watchPurchases() =>
      _inAppPurchase.purchaseStream;

  @override
  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  @override
  Future<SubscriptionInfo> verifyAndPersistPurchase({
    required String userId,
    required PurchaseDetails purchase,
  }) async {
    final verification = await _remoteDataSource.verifySubscription(
      userId: userId,
      receiptData: purchase.verificationData.serverVerificationData,
      platform: Platform.isIOS ? 'ios' : 'android',
    );

    if (!verification.isValid) {
      await _persistSubscription(
        isPremium: false,
        expiryDate: null,
        planType: null,
      );
      throw Exception('Receipt validation failed.');
    }

    final info = SubscriptionInfo(
      isPremium: true,
      expiryDate: verification.expiryDate,
      planType: verification.plan,
    );

    await _persistSubscription(
      isPremium: info.isPremium,
      expiryDate: info.expiryDate,
      planType: info.planType,
    );

    return info;
  }

  @override
  Future<SubscriptionInfo> readPersistedSubscription() async {
    final isPremium = _sharedPreferences.getBool(_isPremiumKey) ?? false;
    final expiryRaw = await _secureStorage.read(key: _expiryDateKey);
    final planType = await _secureStorage.read(key: _planTypeKey);

    final expiry = expiryRaw != null ? DateTime.tryParse(expiryRaw) : null;
    return SubscriptionInfo(
      isPremium: isPremium,
      expiryDate: expiry,
      planType: planType,
    );
  }

  @override
  Future<SubscriptionInfo> refreshSubscriptionStatus() async {
    final persisted = await readPersistedSubscription();

    if (persisted.expiryDate == null || persisted.isExpired) {
      await _persistSubscription(
        isPremium: false,
        expiryDate: null,
        planType: null,
      );

      return const SubscriptionInfo(
        isPremium: false,
        expiryDate: null,
        planType: null,
      );
    }

    return persisted;
  }

  Future<void> _persistSubscription({
    required bool isPremium,
    required DateTime? expiryDate,
    required String? planType,
  }) async {
    await _sharedPreferences.setBool(_isPremiumKey, isPremium);

    if (expiryDate != null) {
      await _secureStorage.write(
        key: _expiryDateKey,
        value: expiryDate.toIso8601String(),
      );
    } else {
      await _secureStorage.delete(key: _expiryDateKey);
    }

    if (planType != null && planType.isNotEmpty) {
      await _secureStorage.write(key: _planTypeKey, value: planType);
    } else {
      await _secureStorage.delete(key: _planTypeKey);
    }
  }
}
