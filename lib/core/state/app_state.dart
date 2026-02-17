enum AppStatus {
  idle,
  loading,
  success,
  error,
}

class AppState<T> {
  final AppStatus status;
  final T? data;
  final String? message;

  const AppState._({
    required this.status,
    this.data,
    this.message,
  });

  factory AppState.idle() => const AppState._(status: AppStatus.idle);

  factory AppState.loading() => const AppState._(status: AppStatus.loading);

  factory AppState.success(T data) =>
      AppState._(status: AppStatus.success, data: data);

  factory AppState.error(String message) =>
      AppState._(status: AppStatus.error, message: message);
}
