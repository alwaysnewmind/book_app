import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  reader,
  writer,
}

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final UserRole role;

  // SaaS Related Fields
  final bool isPremium;
  final DateTime? subscriptionExpiry;

  // Metadata
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

  /// 🔄 Convert Firestore → AppUser
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
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// 🔄 Convert AppUser → Firestore
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

  /// 🔁 CopyWith (Future updates ke liye)
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
}
