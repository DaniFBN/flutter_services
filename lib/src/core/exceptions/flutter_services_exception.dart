class FlutterServicesException implements Exception {
  final String message;
  final String code;
  final StackTrace stackTrace;
  final Object? innerException;
  final StackTrace? innerStacktrace;

  FlutterServicesException(
    this.message, {
    required this.code,
    this.innerException,
    this.innerStacktrace,
    StackTrace? stackTrace,
  }) : stackTrace = stackTrace ?? StackTrace.current;
}
