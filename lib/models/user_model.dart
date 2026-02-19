import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  reader,
  writer,
  admin,
}

enum UserMode {
  reader,
  writer,
  author,
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final UserRole role;
  final UserMode currentMode;
  final DateTime createdAt;
  final bool hasCompletedOnboarding;
  final List<String> selectedGenres;

  // 🔥 Onboarding Fields
  final String? profileImageUrl;

  /// Permanent Role (admin / system level)

  /// 🔁 Current App Mode (Reader ↔ Writer toggle)
  // =============================
  // 🔐 Reader Subscription
  // =============================
  final bool isPremium;
  final DateTime? subscriptionExpiry;

  // =============================
  // ✍ Writer Access Control
  // =============================
  final DateTime? writerTrialStart;
  final bool isWriterPremium;

  // =============================
  // 📅 Metadata
  // =============================

  final DateTime updatedAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.currentMode,
    required this.createdAt,
    required this.updatedAt,
    required this.hasCompletedOnboarding,
    required this.selectedGenres,
    this.photoUrl,
    this.profileImageUrl,
    this.isPremium = false,
    this.subscriptionExpiry,
    this.writerTrialStart,
    this.isWriterPremium = false,
  });

  // =============================
  // 🔄 Firestore → AppUser
  // =============================
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      profileImageUrl: map['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.reader,
      ),
      currentMode: UserMode.values.firstWhere(
        (e) => e.name == map['currentMode'],
        orElse: () => UserMode.reader,
      ),
      isPremium: map['isPremium'] ?? false,
      subscriptionExpiry: map['subscriptionExpiry'] != null
          ? (map['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      writerTrialStart: map['writerTrialStart'] != null
          ? (map['writerTrialStart'] as Timestamp).toDate()
          : null,
      isWriterPremium: map['isWriterPremium'] ?? false,
      hasCompletedOnboarding:
          map['hasCompletedOnboarding'] ?? false,
      selectedGenres:
          List<String>.from(map['selectedGenres'] ?? []),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // =============================
  // 🔄 AppUser → Firestore
  // =============================
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'currentMode': currentMode.name,
      'isPremium': isPremium,
      'subscriptionExpiry': subscriptionExpiry,
      'writerTrialStart': writerTrialStart,
      'isWriterPremium': isWriterPremium,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'selectedGenres': selectedGenres,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // =============================
  // 🔁 CopyWith
  // =============================
  AppUser copyWith({
    String? name,
    String? photoUrl,
    String? profileImageUrl,
    UserRole? role,
    UserMode? currentMode,
    bool? isPremium,
    DateTime? subscriptionExpiry,
    DateTime? writerTrialStart,
    bool? isWriterPremium,
    bool? hasCompletedOnboarding,
    List<String>? selectedGenres,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      profileImageUrl:
          profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      currentMode: currentMode ?? this.currentMode,
      isPremium: isPremium ?? this.isPremium,
      subscriptionExpiry:
          subscriptionExpiry ?? this.subscriptionExpiry,
      writerTrialStart:
          writerTrialStart ?? this.writerTrialStart,
      isWriterPremium:
          isWriterPremium ?? this.isWriterPremium,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      selectedGenres:
          selectedGenres ?? this.selectedGenres,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // =============================
  // 📖 Reader Subscription Check
  // =============================
  bool get hasActiveSubscription {
    if (!isPremium) return false;
    if (subscriptionExpiry == null) return false;
    return subscriptionExpiry!.isAfter(DateTime.now());
  }

  // =============================
  // ✍ Writer Trial Check (7 Days)
  // =============================
  bool get hasActiveWriterTrial {
    if (writerTrialStart == null) return true;

    final difference =
        DateTime.now().difference(writerTrialStart!).inDays;

    return difference < 7;
  }

  bool get canAccessWriter {
    if (isWriterPremium) return true;
    return hasActiveWriterTrial;
  }

  // =============================
  // Helpers
  // =============================
  bool get isWriterMode => currentMode == UserMode.writer;
  bool get isReaderMode => currentMode == UserMode.reader;
}
