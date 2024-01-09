library liber_ebooks;

import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:liber_epub/core/utils/get_epub_root_file_path.dart';
import 'package:liber_epub/core/utils/parse_epub_package.dart';
import 'package:liber_epub/core/utils/process_package.dart';

class Reader {
  Future<void> decompressEpub(String path, {String? password}) async {
    final file = _getFileIfValid(path);
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final rootFilePath = await getEpubRootFilePath(archive);
    final rootFile = _getRootFile(archive, rootFilePath);

    final package = parsePackage(
      convert.utf8.decode(rootFile.content as List<int>),
    );
    processPackage(package, archive, rootFilePath);
  }

  File _getFileIfValid(String path) {
    if (path.isEmpty) throw Exception('Path cannot be empty');

    final filePath = _sanitizePath(path);
    final file = File(filePath);
    if (!file.existsSync()) throw Exception('No such file or directory');

    return file;
  }

  String _sanitizePath(String input) {
    final Uri uri = Uri.parse(input);
    List<String> segments = uri.pathSegments;
    segments = segments
        .where(
          (segment) => segment.isNotEmpty && segment != '.' && segment != '..',
        )
        .toList();

    return Uri.parse(segments.join('/')).toString();
  }

  ArchiveFile _getRootFile(Archive archive, String? rootFilePath) {
    if (rootFilePath == null) throw Exception('No root file found');
    return archive.files.firstWhere(
      (testFile) => testFile.name == rootFilePath,
      orElse: () => throw Exception(
        'EPUB parsing error: root file not found.',
      ),
    );
  }
}
