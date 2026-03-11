import 'package:book_app/features/home/mainicon/setting_icon/models/settings_model.dart' show SettingsModel;


class SettingsService {

  Future<SettingsModel> loadSettings() async {

    await Future.delayed(const Duration(milliseconds: 200));

    return const SettingsModel(
      darkMode: false,
      notifications: true,
    );
  }

  Future<void> saveSettings(SettingsModel settings) async {

    await Future.delayed(const Duration(milliseconds: 200));

    /// Here later:
    /// SharedPreferences
    /// Firestore
    /// Remote Config
  }
}