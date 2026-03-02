import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/premium_remote_datasource.dart';
import '../data/premium_repository_impl.dart';
import '../domain/premium_repository.dart';
import '../domain/purchase_subscription.dart';
import 'premium_controller.dart';
import 'premium_state.dart';

const _apiBaseUrl = String.fromEnvironment(
  'PREMIUM_API_BASE_URL',
  defaultValue: 'https://your-production-api.com',
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Initialize SharedPreferences in main.dart'),
);

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Content-Type': 'application/json'},
    ),
  );
});

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final inAppPurchaseProvider = Provider<InAppPurchase>((ref) {
  return InAppPurchase.instance;
});

final premiumRemoteDataSourceProvider = Provider<PremiumRemoteDataSource>((ref) {
  return PremiumRemoteDataSource(ref.read(dioProvider));
});

final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  return PremiumRepositoryImpl(
    inAppPurchase: ref.read(inAppPurchaseProvider),
    remoteDataSource: ref.read(premiumRemoteDataSourceProvider),
    sharedPreferences: ref.read(sharedPreferencesProvider),
    secureStorage: ref.read(secureStorageProvider),
  );
});

final purchaseSubscriptionProvider = Provider<PurchaseSubscription>((ref) {
  return PurchaseSubscription(ref.read(premiumRepositoryProvider));
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final premiumControllerProvider =
    StateNotifierProvider<PremiumController, PremiumState>((ref) {
  return PremiumController(
    purchaseSubscription: ref.read(purchaseSubscriptionProvider),
    firebaseAuth: ref.read(firebaseAuthProvider),
  );
});
