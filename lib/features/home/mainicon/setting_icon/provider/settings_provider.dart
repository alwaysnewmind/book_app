import 'package:book_app/features/home/mainicon/setting_icon/models/settings_model.dart' show SettingsModel;
import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {

  final SettingsService _service = SettingsService();

  SettingsModel _settings = const SettingsModel(
    darkMode: false,
    notifications: true,
  );

  SettingsModel get settings => _settings;

  bool get darkMode => _settings.darkMode;
  bool get notifications => _settings.notifications;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Load settings
  Future<void> loadSettings() async {

    _isLoading = true;
    notifyListeners();

    try {
      _settings = await _service.loadSettings();
    } catch (e) {
      debugPrint("Settings load error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle Dark Mode
  Future<void> toggleDarkMode(bool value) async {

    _settings = _settings.copyWith(darkMode: value);

    notifyListeners();

    await _service.saveSettings(_settings);
  }

  /// Toggle Notifications
  Future<void> toggleNotifications(bool value) async {

    _settings = _settings.copyWith(notifications: value);

    notifyListeners();

    await _service.saveSettings(_settings);
  }
}