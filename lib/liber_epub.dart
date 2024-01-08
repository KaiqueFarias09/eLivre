library liber_epub;

import 'dart:io';

import 'package:liber_epub/zip_local_file_header.dart';

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
