/// Represents the status of any asynchronous operation
enum AppStatus {
  idle,
  loading,
  success,
  error,
}

/// Generic AppState class for handling UI state
class AppState<T> {
  final AppStatus status;
  final T? data;
  final String? message;

  const AppState._({
    required this.status,
    this.data,
    this.message,
  });

  /// Idle state
  factory AppState.idle() => const AppState._(status: AppStatus.idle);

  /// Loading state
  factory AppState.loading() => const AppState._(status: AppStatus.loading);

  /// Success state with data
  factory AppState.success(T data) =>
      AppState._(status: AppStatus.success, data: data);

  /// Error state with message
  factory AppState.error(String message) =>
      AppState._(status: AppStatus.error, message: message);

  /// Helper getters for easier checks
  bool get isIdle => status == AppStatus.idle;
  bool get isLoading => status == AppStatus.loading;
  bool get isSuccess => status == AppStatus.success;
  bool get isError => status == AppStatus.error;
}
