class EmptyBytesException implements Exception {
  EmptyBytesException([this.message = 'Bytes cannot be empty']);
  final String message;

  @override
  String toString() => 'EmptyBytesException: $message';
}
