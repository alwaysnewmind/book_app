import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { reader, writer, admin }

enum UserMode { reader, writer, author }

class AppUser {
  // Core Identity
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String city;
  final DateTime? dob;
  final String gender;
  final String? photoUrl;
  final String? profileImageUrl;

  // Roles & Modes
  final UserRole role;
  final UserMode currentMode;

  // Reader Subscription
  final bool isPremium;
  final DateTime? subscriptionExpiry;
  final DateTime? premiumActivatedAt;
  final DateTime? premiumExpiry;

  // Writer Access
  final DateTime? writerTrialStart;
  final bool isWriterPremium;

  // Onboarding
  final bool hasCompletedOnboarding;
  final List<String> selectedGenres;
  final List<String> favoriteGenres;
  final bool hasActiveSubscription;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  // Social + monetization
  final int followersCount;
  final int followingCount;
  final double totalEarnings;
  final double availableBalance;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.city,
    required this.gender,
    required this.role,
    required this.currentMode,
    required this.createdAt,
    required this.updatedAt,
    required this.hasCompletedOnboarding,
    required this.selectedGenres,
    required this.favoriteGenres,
    this.photoUrl,
    this.profileImageUrl,
    this.isPremium = false,
    this.subscriptionExpiry,
    this.premiumActivatedAt,
    this.premiumExpiry,
    this.writerTrialStart,
    this.isWriterPremium = false,
    this.dob,
    required this.hasActiveSubscription,
    this.followersCount = 0,
    this.followingCount = 0,
    this.totalEarnings = 0,
    this.availableBalance = 0,
  
  });

  // ===============================
  // SAFE DATE PARSER
  // ===============================

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  // ===============================
  // Firestore → AppUser
  // ===============================

  factory AppUser.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      throw ArgumentError('User map cannot be null');
    }

    return AppUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      city: map['city'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      dob: _parseDate(map['dob']),
      photoUrl: map['photoUrl'] as String?,
      profileImageUrl: map['profileImageUrl'] as String?,
      hasActiveSubscription: false,

      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.reader,
      ),

      currentMode: UserMode.values.firstWhere(
        (e) => e.name == map['currentMode'],
        orElse: () => UserMode.reader,
      ),

      isPremium: map['isPremium'] as bool? ?? false,
      subscriptionExpiry: _parseDate(map['subscriptionExpiry']),
      premiumActivatedAt: _parseDate(map['premiumActivatedAt']),
      premiumExpiry: _parseDate(map['premiumExpiry']),
      writerTrialStart: _parseDate(map['writerTrialStart']),
      isWriterPremium: map['isWriterPremium'] as bool? ?? false,
      hasCompletedOnboarding:
          map['hasCompletedOnboarding'] as bool? ?? false,

      selectedGenres:
          List<String>.from(map['selectedGenres'] ?? const []),

      favoriteGenres:
          List<String>.from(map['favoriteGenres'] ?? const []),

      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(map['updatedAt']) ?? DateTime.now(),
      followersCount: (map['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (map['followingCount'] as num?)?.toInt() ?? 0,
      totalEarnings: (map['totalEarnings'] as num?)?.toDouble() ?? 0,
      availableBalance: (map['availableBalance'] as num?)?.toDouble() ?? 0,
    );
  }

  // ===============================
  // AppUser → Firestore
  // ===============================

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'gender': gender,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'photoUrl': photoUrl,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'currentMode': currentMode.name,
      'isPremium': isPremium,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
      'premiumActivatedAt': premiumActivatedAt != null
          ? Timestamp.fromDate(premiumActivatedAt!)
          : null,
      'premiumExpiry': premiumExpiry != null
          ? Timestamp.fromDate(premiumExpiry!)
          : null,
      'writerTrialStart': writerTrialStart != null
          ? Timestamp.fromDate(writerTrialStart!)
          : null,
      'isWriterPremium': isWriterPremium,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'selectedGenres': selectedGenres,
      'favoriteGenres': favoriteGenres,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'totalEarnings': totalEarnings,
      'availableBalance': availableBalance,
    };
  }

  // ===============================
  // COPY WITH
  // ===============================

  AppUser copyWith({
    String? name,
    String? phone,
    String? city,
    String? gender,
    DateTime? dob,
    String? photoUrl,
    String? profileImageUrl,
    UserRole? role,
    UserMode? currentMode,
    bool? isPremium,
    DateTime? subscriptionExpiry,
    DateTime? premiumActivatedAt,
    DateTime? premiumExpiry,
    DateTime? writerTrialStart,
    bool? isWriterPremium,
    bool? hasCompletedOnboarding,
    List<String>? selectedGenres,
    List<String>? favoriteGenres,
    int? followersCount,
    int? followingCount,
    double? totalEarnings,
    double? availableBalance,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      photoUrl: photoUrl ?? this.photoUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      currentMode: currentMode ?? this.currentMode,
      isPremium: isPremium ?? this.isPremium,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      premiumActivatedAt: premiumActivatedAt ?? this.premiumActivatedAt,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
      writerTrialStart: writerTrialStart ?? this.writerTrialStart,
      isWriterPremium: isWriterPremium ?? this.isWriterPremium,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      hasActiveSubscription: hasActiveSubscription,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      availableBalance: availableBalance ?? this.availableBalance,
    );
  }
}
