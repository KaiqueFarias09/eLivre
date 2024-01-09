library liber_ebooks;

import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:liber_epub/core/utils/get_epub_root_file_path.dart';
import 'package:liber_epub/core/utils/parse_epub_package.dart';

class Reader {
  Future<void> decompressEpub(String path, {String? password}) async {
    if (path.isEmpty) throw Exception('Path cannot be empty');

    // TODO: Sanitize the path input to avoid possible path traversal attacks
    final file = File(path);
    if (!file.existsSync()) throw Exception('No such file or directory');

    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final rootFilePath = await getEpubRootFilePath(archive);
    if (rootFilePath == null) {
      throw Exception('No root file found');
    }

    final rootFile = archive.files.firstWhere(
      (ArchiveFile testFile) => testFile.name == rootFilePath,
      orElse: () => throw Exception('EPUB parsing error: root file not found.'),
    );
    final rootFileContent = convert.utf8.decode(rootFile.content as List<int>);
    final package = parsePackage(rootFileContent);
    print(package.guide);
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
