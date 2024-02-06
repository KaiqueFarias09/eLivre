import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:e_livre/features/epub/entities/book/files.dart';
import 'package:e_livre/features/epub/entities/file/binary_file.dart';
import 'package:e_livre/features/epub/entities/file/text_file.dart';
import 'package:e_livre/features/epub/entities/navigation/navigation.dart';
import 'package:e_livre/features/epub/entities/package/epub_package.dart';
import 'package:e_livre/features/epub/utils/extract_files.dart';
import 'package:e_livre/features/epub/utils/get_book_cover.dart';
import 'package:e_livre/features/epub/utils/get_epub_root_file_path.dart';
import 'package:e_livre/features/epub/utils/parse_epub_package.dart';
import 'package:e_livre/features/epub/utils/process_package.dart';
import 'package:e_livre/features/epub/exceptions/empty_bytes_exception.dart';
import 'package:e_livre/features/epub/exceptions/epub_exception.dart';
import 'package:path/path.dart' as path;

class EpubBook {
  EpubBook({
    required this.navigation,
    required this.files,
    required this.cover,
    required this.package,
  });

  static Future<EpubBook> fromFilePath(final String path) {
    final file = _getFileIfValid(path);
    final bytes = file.readAsBytesSync();

    return _readBook(bytes);
  }

  static Future<EpubBook> fromFile(final File file) {
    final bytes = file.readAsBytesSync();
    if (!file.existsSync()) throw EpubException('No such file or directory');

    return _readBook(bytes);
  }

  static Future<EpubBook> fromBytes(final List<int> bytes) {
    if (bytes.isEmpty) throw EmptyBytesException();
    return _readBook(bytes);
  }

  final Navigation navigation;
  final Files files;
  final BinaryFile cover;
  final EpubPackage package;

  String get title => package.metadata.title;
  String? get creator => package.metadata.creator;
  String get language => package.metadata.language;
  String? get publisher => package.metadata.publisher;
  String get date => package.metadata.date;
  String get uid => package.metadata.uniqueIdentifierValue;
  String get version => package.version;
  List<TextFile> get content => files.html;
  List<BinaryFile> get images => files.images;

  /// Reads an EPUB book from the provided bytes and decodes them into an archive.
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
  /// [bytes] are the bytes to read.
  ///
  /// Returns a `Future` that completes with the `EpubBook` representing the
  /// read book.
  ///
  /// Throws an `EpubException` if the root file path could not be found, the root
  /// file could not be found, or the TOC ID is empty when getting the navigation.
  static Future<EpubBook> _readBook(final List<int> bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);

    final rootFilePath = await getEpubRootFilePath(archive);
    final rootFile = _getRootFile(archive, rootFilePath).content as List<int>;

    final package = parsePackage(convert.utf8.decode(rootFile));
    final navigation = getEpubNavigation(package, archive, rootFilePath);

    final files = extractFiles(archive.files, package.manifest.items);
    final cover = getBookCover(package.manifest.items, files.images);

    return EpubBook(
      navigation: navigation,
      files: files,
      cover: cover,
      package: package,
    );
  }

  static File _getFileIfValid(final String filePath) {
    if (filePath.isEmpty) throw EpubException('Path cannot be empty');

    final sanitizedPath = path.normalize(filePath);
    final file = File(sanitizedPath);
    if (!file.existsSync()) throw EpubException('No such file or directory');

    return file;
  }

  static ArchiveFile _getRootFile(
    final Archive archive,
    final String? rootFilePath,
  ) {
    if (rootFilePath == null) throw EpubException('No root file found');
    final rootFile = archive.findFile(rootFilePath);
    return rootFile ?? (throw EpubException('No root file found'));
  }
}
