import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:e_livre/features/epub/entities/book/files.dart';
import 'package:e_livre/features/epub/entities/file/binary_file.dart';
import 'package:e_livre/features/epub/entities/file/text_file.dart';
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';
import 'package:e_livre/features/epub/entities/package/epub_package.dart';
import 'package:path/path.dart' as path;

/// Extracts various types of files from an EPUB archive.
///
/// This function extracts images, CSS files, HTML files, font files, and other files from the provided archive and package.
/// It uses helper functions to extract each type of file.
///
/// [archive] is the `Archive` from which to extract the files.
/// [package] is the `EpubPackage` that contains the manifest items to use when extracting the files.
///
/// Returns a `Files` object containing the extracted files.
Files extractFiles(
  final Archive archive,
  final EpubPackage package,
) {
  return Files(
    images: _getImages(archive, package),
    css: _getCSSFiles(archive, package),
    html: _getHTMLFiles(archive, package),
    fonts: _getFontFiles(archive, package),
    others: _getOtherFiles(archive, package),
  );
}

List<BinaryFile> _getImages(
  final Archive archive,
  final EpubPackage package,
) {
  final imageItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('image/'),
  );
  final imageFiles = _getFilesFromItems(archive, imageItems);

  return imageFiles
      .map(
        (final image) => BinaryFile(
          name: path.basename(image.name),
          type: image.name.split('.').last,
          path: image.name,
          content: Uint8List.fromList(
            image.content as List<int>,
          ),
        ),
      )
      .toList();
}

List<TextFile> _getCSSFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final cssItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('text/css'),
  );
  final cssFiles = _getFilesFromItems(archive, cssItems);

  return cssFiles.map((final file) {
    return TextFile(
      path: file.name,
      content: convert.utf8.decode(file.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<TextFile> _getHTMLFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final htmlItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('application/xhtml+xml'),
  );
  final htmlFiles = _getFilesFromItems(archive, htmlItems);

  return htmlFiles.map((final file) {
    return TextFile(
      path: file.name,
      content: convert.utf8.decode(file.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<BinaryFile> _getFontFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final fontItems = package.manifest.items.where(
    (final item) =>
        item.mediaType.contains('application/font-woff') ||
        item.mediaType.contains('application/vnd.ms-opentype'),
  );
  final fontFiles = _getFilesFromItems(archive, fontItems);
  return fontFiles.map((final file) {
    return BinaryFile(
      path: file.name,
      content: Uint8List.fromList(file.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<BinaryFile> _getOtherFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final otherItems = package.manifest.items.where((final item) =>
      !item.mediaType.contains('image/') &&
      !item.mediaType.contains('text/css') &&
      !item.mediaType.contains('application/xhtml+xml') &&
      !item.mediaType.contains('application/font-woff') &&
      !item.mediaType.contains('application/vnd.ms-opentype'));

  final files = _getFilesFromItems(archive, otherItems);
  return files.map(
    (final file) {
      return BinaryFile(
        path: file.name,
        content: Uint8List.fromList(file.content as List<int>),
        name: path.basename(file.name),
        type: file.name.split('.').last,
      );
    },
  ).toList();
}

// TODO: Change this to receive a list of archive files
// instead of the archive itself.
List<ArchiveFile> _getFilesFromItems(
  final Archive archive,
  final Iterable<ManifestItem> items,
) {
  final List<ArchiveFile> archiveFiles = [];
  for (final item in items) {
    final file = archive.files.firstWhereOrNull(
      (final file) => file.name.contains(item.path),
    );

    if (file != null) {
      archiveFiles.add(file);
    }
  }
  return archiveFiles;
}
