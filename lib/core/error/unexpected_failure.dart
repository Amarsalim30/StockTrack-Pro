class UnexpectedFailure implements Exception {
  final String message;

  UnexpectedFailure([this.message = 'An unexpected error occurred.']);

  @override
  String toString() {
    return 'UnexpectedFailure: $message';
  }
}