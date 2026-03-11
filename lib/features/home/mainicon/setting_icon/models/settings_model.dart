class SettingsModel {
  final bool darkMode;
  final bool notifications;

  const SettingsModel({
    required this.darkMode,
    required this.notifications,
  });

  SettingsModel copyWith({
    bool? darkMode,
    bool? notifications,
  }) {
    return SettingsModel(
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notifications': notifications,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      darkMode: map['darkMode'] ?? false,
      notifications: map['notifications'] ?? true,
    );
  }
}