class EpubException implements Exception {
  EpubException(this.message);

  final String message;

  @override
  String toString() => 'EpubException: $message';
}
