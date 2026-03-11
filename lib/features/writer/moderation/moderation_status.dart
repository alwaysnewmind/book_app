enum ModerationStatus {
  safe,
  warning,
  blocked,
}

class ModerationResult {
  final ModerationStatus status;
  final String message;

  ModerationResult({
    required this.status,
    required this.message,
  });
}