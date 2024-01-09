library liber_ebooks;

import 'dart:io';

import 'package:archive/archive.dart';
import 'package:liber_epub/core/utils/get_epub_root_file_path.dart';

class Reader {
  static Future decompressEpub(String path, {String? password}) async {
    path.isEmpty ? throw Exception('Path cannot be empty') : null;

    final file = File(path);
    if (!await file.exists()) throw Exception('No such file or directory');

    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final rootFilePath = await getRootFilePath(archive);
    print(rootFilePath);
  }
}

String getDirectoryPath(String filePath) {
  final lastSlashIndex = filePath.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    return '';
  } else {
    return filePath.substring(0, lastSlashIndex);
  }
}
