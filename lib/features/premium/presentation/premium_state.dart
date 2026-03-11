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
    this.status = PremiumStatus.initial,
    this.message,
    this.isProcessing = false,
    this.isPremium = false,
    this.expiryDate,
    this.planType,
  });

  /// Initial state
  factory PremiumState.initial() {
    return const PremiumState();
  }

  /// CopyWith
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

  bool get isLoading => status == PremiumStatus.loading;
  bool get hasError => status == PremiumStatus.error;
  bool get isActive => status == PremiumStatus.premiumActive && isPremium;
}