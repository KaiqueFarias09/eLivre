import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:liber_epub/features/epub/entities/book/book.dart';
import 'package:liber_epub/features/epub/utils/extract_files.dart';
import 'package:liber_epub/features/epub/utils/get_book_cover.dart';
import 'package:liber_epub/features/epub/utils/get_epub_root_file_path.dart';
import 'package:liber_epub/features/epub/utils/parse_epub_package.dart';
import 'package:liber_epub/features/epub/utils/process_package.dart';

Future<EpubBook> readBook(
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

  final files = extractFiles(archive, package);
  final cover = getBookCover(package.manifest.items, files.images);

  return EpubBook(
    navigation: navigation,
    files: files,
    cover: cover,
    package: package,
  );
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
  segments = segments.where((final segment) {
    return segment.isNotEmpty && segment != '.' && segment != '..';
  }).toList();

  return Uri.parse(segments.join('/')).toString();
}

ArchiveFile _getRootFile(final Archive archive, final String? rootFilePath) {
  if (rootFilePath == null) throw Exception('No root file found');
  final rootFile = archive.findFile(rootFilePath);
  return rootFile ?? (throw Exception('No root file found'));
}
