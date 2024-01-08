library liber_epub;

import 'dart:io';
import 'dart:typed_data';

import 'package:liber_epub/zip_local_file_header.dart';

const EOCD_SIGNATURE = 0x06054b50;
const ZIP_SIGNATURE = 0x02014b50;

class Reader {
  static Future decompressEpub(String path, String password) async {
    path.isEmpty ? throw Exception('Path cannot be empty') : null;

    final file = File(path);
    if (!await file.exists()) throw Exception('No such file or directory');

    final bytes = await file.readAsBytes();
    final headers = parseLocalFileHeaders(bytes);
    for (var header in headers) {
      print(header.fileName);
    }
  }
}

ByteBuffer findEocdrSignature(Uint8List bytes) {
  for (int i = bytes.lengthInBytes - 4; i >= 0; i--) {
    final buffer = bytes.buffer;

    final potentialSignature = buffer.asByteData().getUint32(i, Endian.little);
    if (potentialSignature == EOCD_SIGNATURE) {
      return bytes.sublist(i).buffer;
    }
  }

  throw Exception('EOCDR not found in zip file');
}
