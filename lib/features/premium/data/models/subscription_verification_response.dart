class SubscriptionVerificationResponse {
  final bool isValid;
  final DateTime? expiryDate;
  final String? plan;

  const SubscriptionVerificationResponse({
    required this.isValid,
    required this.expiryDate,
    required this.plan,
  });

  factory SubscriptionVerificationResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionVerificationResponse(
      isValid: json['isValid'] == true,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'].toString())
          : null,
      plan: json['plan']?.toString(),
    );
  }
}
