library liber_ebooks;

import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:liber_epub/features/epub/usecases/epub_file_extractor.dart';
import 'package:liber_epub/features/epub/utils/get_book_cover.dart';
import 'package:liber_epub/features/epub/utils/get_epub_root_file_path.dart';
import 'package:liber_epub/features/epub/utils/parse_epub_package.dart';
import 'package:liber_epub/features/epub/utils/process_package.dart';

class Reader {
  Future<void> decompressEpub(
    final String path, {
    final String? password,
  }) async {
    final file = _getFileIfValid(path);
    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    final rootFilePath = await getEpubRootFilePath(archive);
    final rootFile = _getRootFile(archive, rootFilePath);

    final package = parsePackage(
      convert.utf8.decode(rootFile.content as List<int>),
    );
    final navigation = getEpubNavigation(package, archive, rootFilePath);
    print(navigation);

    final files = EpubFileExtractor().execute(archive, package);
    final bookCover = getBookCover(package.manifest.items, files.images);

    print({bookCover.name, bookCover.path, bookCover.type});
  }

  File _getFileIfValid(final String path) {
    if (path.isEmpty) throw Exception('Path cannot be empty');

    final filePath = _sanitizePath(path);
    final file = File(filePath);
    if (!file.existsSync()) throw Exception('No such file or directory');

    return file;
  }

  String _sanitizePath(final String input) {
    final Uri uri = Uri.parse(input);
    List<String> segments = uri.pathSegments;
    segments = segments
        .where(
          (final segment) =>
              segment.isNotEmpty && segment != '.' && segment != '..',
        )
        .toList();

    return Uri.parse(segments.join('/')).toString();
  }

  ArchiveFile _getRootFile(
    final Archive archive,
    final String? rootFilePath,
  ) {
    if (rootFilePath == null) throw Exception('No root file found');
    return archive.files.firstWhere(
      (final testFile) => testFile.name == rootFilePath,
      orElse: () => throw Exception(
        'EPUB parsing error: root file not found.',
      ),
    );
  }
}
