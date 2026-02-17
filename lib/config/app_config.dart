enum AppEnvironment { dev, prod }

class AppConfig {
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final bool enablePayments;

  static late AppConfig _instance;

  AppConfig._({
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enablePayments,
  });

  static void initialize(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        _instance = AppConfig._(
          appName: "BookApp Dev",
          baseUrl: "LOCAL", // no domain yet
          enableLogging: true,
          enablePayments: false,
        );
        break;

      case AppEnvironment.prod:
        _instance = AppConfig._(
          appName: "BookApp",
          baseUrl: "LOCAL", // will change later
          enableLogging: false,
          enablePayments: true,
        );
        break;
    }
  }

  static AppConfig get instance => _instance;
}
