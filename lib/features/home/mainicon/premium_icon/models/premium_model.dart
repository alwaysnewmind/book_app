import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumModel {
  final bool isPremium;
  final DateTime? expiryDate;
  final bool trialUsed;

  PremiumModel({
    required this.isPremium,
    required this.expiryDate,
    required this.trialUsed,
  });

  factory PremiumModel.fromMap(Map<String, dynamic> map) {
    final expiryValue = map['premiumExpiry'];

    DateTime? expiry;

    if (expiryValue is Timestamp) {
      expiry = expiryValue.toDate();
    } else if (expiryValue is DateTime) {
      expiry = expiryValue;
    } else {
      expiry = null;
    }

    return PremiumModel(
      isPremium: map['isPremium'] ?? false,
      expiryDate: expiry,
      trialUsed: map['trialUsed'] ?? false,
    );
  }

  /// 🔥 REAL LOGIC: Is premium currently active?
  bool get isActive {
    if (!isPremium) return false;
    if (expiryDate == null) return false;

    return DateTime.now().isBefore(expiryDate!);
  }

  /// 🔥 Check if expired
  bool get isExpired {
    if (expiryDate == null) return true;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// 🔥 Days left
  int get remainingDays {
    if (expiryDate == null) return 0;

    final difference = expiryDate!.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'isPremium': isPremium,
      'premiumExpiry': expiryDate,
      'trialUsed': trialUsed,
    };
  }
}