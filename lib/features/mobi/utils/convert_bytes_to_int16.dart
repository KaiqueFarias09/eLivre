import 'dart:typed_data';

int convertBytesToInt16(final List<int> bytes) {
  final buffer = Uint8List.fromList(bytes).buffer;
  final data = ByteData.view(buffer);
  return data.getInt16(0);
}

