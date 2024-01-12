import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:e_livre/features/epub/entities/book/book.dart';
import 'package:e_livre/features/epub/utils/extract_files.dart';
import 'package:e_livre/features/epub/utils/get_book_cover.dart';
import 'package:e_livre/features/epub/utils/get_epub_root_file_path.dart';
import 'package:e_livre/features/epub/utils/parse_epub_package.dart';
import 'package:e_livre/features/epub/utils/process_package.dart';
import 'package:path/path.dart' as path;

/// Reads an EPUB book from the provided path.
///
/// The function first checks if the file at the path is valid, then reads its
/// bytes and decodes them into an archive.
///
/// It then retrieves the root file path and root file from the archive, and
/// parses the root file into a package.
///
/// It also retrieves the navigation of the EPUB from the package and archive,
/// and extracts the files from the archive and package.
///
/// Finally, it retrieves the cover of the book from the package's manifest
/// items and the extracted images, and creates an `EpubBook` from the
/// retrieved data.
///
/// [path] is the path to the EPUB file to read.
///
/// Returns a `Future` that completes with the `EpubBook` representing the
/// read book.
///
/// Throws an `Exception` if the file at the path is not valid, the root file
/// path could not be found, the root file could not be found, or the TOC ID is
/// empty when getting the navigation.
Future<EpubBook> readBook(final String path) async {
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

File _getFileIfValid(final String filePath) {
  if (filePath.isEmpty) throw Exception('Path cannot be empty');

  final sanitizedPath = path.normalize(filePath);
  final file = File(sanitizedPath);
  if (!file.existsSync()) throw Exception('No such file or directory');

  return file;
}

ArchiveFile _getRootFile(final Archive archive, final String? rootFilePath) {
  if (rootFilePath == null) throw Exception('No root file found');
  final rootFile = archive.findFile(rootFilePath);
  return rootFile ?? (throw Exception('No root file found'));
}
