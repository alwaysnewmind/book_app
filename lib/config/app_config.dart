enum AppEnvironment { dev, prod }

class AppConfig {
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final bool enablePayments;

  static late final AppConfig _instance;

  AppConfig._({
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enablePayments,
  });

  /// Initialize config based on environment
  static void initialize(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        _instance = AppConfig._(
          appName: "BookApp Dev",
          baseUrl: "local", // safer placeholder URL
          enableLogging: true,
          enablePayments: false,
        );
        break;

      case AppEnvironment.prod:
        _instance = AppConfig._(
          appName: "BookApp",
          baseUrl: "Local", // replace later with real prod URL
          enableLogging: false,
          enablePayments: true,
        );
        break;
    }
  }

  /// Global access to AppConfig instance
  static AppConfig get instance {
    // ignore: unnecessary_null_comparison
    if (_instance == null) {
      throw Exception(
        "AppConfig not initialized! Call AppConfig.initialize(env) first.",
      );
    }
    return _instance;
  }

  /// Helper: check if payments enabled
  bool get canProcessPayments => enablePayments;

  /// Helper: check if logging enabled
  bool get isLoggingEnabled => enableLogging;
}
