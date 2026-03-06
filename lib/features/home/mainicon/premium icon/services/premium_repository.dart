import 'premium_remote_service.dart';

class PremiumRepository {
  final PremiumRemoteService remoteService;

  PremiumRepository(this.remoteService);

  Future<void> startFreeTrial() async {
    await remoteService.activateTrial();
  }

  Future<void> restorePurchase() async {
    await remoteService.restorePurchase();
  }
}