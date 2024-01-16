import 'dart:typed_data';

int convertBytesToInt32(final List<int> bytes) {
  final buffer = Uint8List.fromList(bytes).buffer;
  final data = ByteData.view(buffer);
  return data.getInt32(0);
}
