enum PremiumStatus {
  initial,
  loading,
  success,
  error,
  premiumActive,
  premiumExpired,
}

class PremiumState {
  final PremiumStatus status;
  final String? message;
  final bool isProcessing;
  final bool isPremium;
  final DateTime? expiryDate;
  final String? planType;

  const PremiumState({
    required this.status,
    required this.message,
    required this.isProcessing,
    required this.isPremium,
    required this.expiryDate,
    required this.planType,
  });

  factory PremiumState.initial() => const PremiumState(
        status: PremiumStatus.initial,
        message: null,
        isProcessing: false,
        isPremium: false,
        expiryDate: null,
        planType: null,
      );

  PremiumState copyWith({
    PremiumStatus? status,
    String? message,
    bool clearMessage = false,
    bool? isProcessing,
    bool? isPremium,
    DateTime? expiryDate,
    bool clearExpiry = false,
    String? planType,
    bool clearPlan = false,
  }) {
    return PremiumState(
      status: status ?? this.status,
      message: clearMessage ? null : (message ?? this.message),
      isProcessing: isProcessing ?? this.isProcessing,
      isPremium: isPremium ?? this.isPremium,
      expiryDate: clearExpiry ? null : (expiryDate ?? this.expiryDate),
      planType: clearPlan ? null : (planType ?? this.planType),
    );
  }
}
