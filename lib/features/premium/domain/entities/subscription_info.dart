class SubscriptionInfo {
  final bool isPremium;
  final DateTime? expiryDate;
  final String? planType;

  const SubscriptionInfo({
    required this.isPremium,
    required this.expiryDate,
    required this.planType,
  });

  bool get isExpired {
    if (!isPremium || expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate!);
  }
}
