/// Typed application exception.
/// Wraps Firebase or network errors with a human-readable message.
class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, {this.cause});

  @override
  String toString() => 'AppException: $message${cause != null ? ' ($cause)' : ''}';
}
