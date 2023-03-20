class InvalidMapUrlException implements Exception {
  const InvalidMapUrlException(this.message);

  final String message;

  @override
  String toString() {
    Object? message = this.message;
    return 'InvalidMapUrlException: $message';
  }
}
