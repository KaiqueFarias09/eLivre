String convertBytesToString(final List<int> bytes) {
  final bytesWithoutNull = List<int>.from(bytes)
    ..removeWhere(
      (final byte) => byte == 0,
    );

  return String.fromCharCodes(bytesWithoutNull);
}
