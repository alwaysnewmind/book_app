import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  reader,
  writer,
  admin,
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final UserRole role;

  // 🔐 Subscription Fields
  final bool isPremium;
  final DateTime? subscriptionExpiry;

  // 📅 Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    this.isPremium = false,
    this.subscriptionExpiry,
  });

  /// 🔄 Firestore → AppUser
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.reader,
      ),
      isPremium: map['isPremium'] ?? false,
      subscriptionExpiry: map['subscriptionExpiry'] != null
          ? (map['subscriptionExpiry'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// 🔄 AppUser → Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role.name,
      'isPremium': isPremium,
      'subscriptionExpiry': subscriptionExpiry,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 🔁 CopyWith (safe updates)
  AppUser copyWith({
    String? name,
    String? photoUrl,
    UserRole? role,
    bool? isPremium,
    DateTime? subscriptionExpiry,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isPremium: isPremium ?? this.isPremium,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 🔐 Check if subscription is ACTIVE
  bool get hasActiveSubscription {
    if (!isPremium) return false;
    if (subscriptionExpiry == null) return false;

    return subscriptionExpiry!.isAfter(DateTime.now());
  }

  /// 👑 Check if user is writer
  bool get isWriter => role == UserRole.writer;

  /// 📖 Check if user is reader
  bool get isReader => role == UserRole.reader;

  
}
