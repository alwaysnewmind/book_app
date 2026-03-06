import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:book_app/features/home/mainicon/premium icon/services/premium_controller.dart';
import 'package:book_app/features/home/mainicon/premium icon/services/premium_remote_service.dart';
import 'package:book_app/features/home/mainicon/premium icon/services/premium_repository.dart';
import 'package:book_app/features/premium/presentation/premium_state.dart';

/// 🔹 Remote Service Provider
final premiumRemoteServiceProvider = Provider<PremiumRemoteService>((ref) {
  return PremiumRemoteService();
});

/// 🔹 Repository Provider
final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  final remoteService = ref.read(premiumRemoteServiceProvider);
  return PremiumRepository(remoteService);
});

/// 🔹 Controller Provider (StateNotifier)
final premiumControllerProvider =
    StateNotifierProvider<PremiumController, PremiumState>((ref) {
  final repository = ref.read(premiumRepositoryProvider);
  return PremiumController(repository);
});