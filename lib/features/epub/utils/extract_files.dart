import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:e_livre/features/epub/entities/book/files.dart';
import 'package:e_livre/features/epub/entities/file/binary_file.dart';
import 'package:e_livre/features/epub/entities/file/text_file.dart';
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';
import 'package:path/path.dart' as path;

/// Extracts various types of files from an EPUB archive.
///
/// This function extracts images, CSS files, HTML files, font files, and other files from the provided archive and package.
/// It uses helper functions to extract each type of file.
///
/// [files] is a list of `ArchiveFile` objects representing the files in the EPUB archive.
/// [items] is a list of `ManifestItem` objects representing the items in the EPUB package's manifest.
///
/// Returns a `Files` object containing the extracted files. The `Files` object includes separate lists for images, CSS files, HTML files, font files, and other files.
Files extractFiles(
  final List<ArchiveFile> files,
  final List<ManifestItem> items,
) {
  return Files(
    images: _getImages(files, items),
    css: _getCSSFiles(files, items),
    html: _getHTMLFiles(files, items),
    fonts: _getFontFiles(files, items),
    others: _getOtherFiles(files, items),
  );
}

List<BinaryFile> _getImages(
  final List<ArchiveFile> files,
  final List<ManifestItem> items,
) {
  final imageItems =
      items.where((final item) => item.mediaType.contains('image/'));
  final imageFiles = _getFilesFromItems(files, imageItems);

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
  final List<ArchiveFile> files,
  final List<ManifestItem> package,
) {
  final cssItems = package.where(
    (final item) => item.mediaType.contains('text/css'),
  );
  final cssFiles = _getFilesFromItems(files, cssItems);

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
  final List<ArchiveFile> files,
  final List<ManifestItem> items,
) {
  final htmlItems = items.where(
    (final item) => item.mediaType.contains('application/xhtml+xml'),
  );
  final htmlFiles = _getFilesFromItems(files, htmlItems);

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
  final List<ArchiveFile> files,
  final List<ManifestItem> items,
) {
  final fontItems = items.where(
    (final item) =>
        item.mediaType.contains('application/font-woff') ||
        item.mediaType.contains('application/vnd.ms-opentype'),
  );
  final fontFiles = _getFilesFromItems(files, fontItems);
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
  final List<ArchiveFile> files,
  final List<ManifestItem> items,
) {
  final otherItems = items.where((final item) =>
      !item.mediaType.contains('image/') &&
      !item.mediaType.contains('text/css') &&
      !item.mediaType.contains('application/xhtml+xml') &&
      !item.mediaType.contains('application/font-woff') &&
      !item.mediaType.contains('application/vnd.ms-opentype'));

  final otherFiles = _getFilesFromItems(files, otherItems);
  return otherFiles.map(
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
  final List<ArchiveFile> files,
  final Iterable<ManifestItem> items,
) {
  final List<ArchiveFile> archiveFiles = [];
  for (final item in items) {
    final file = files.firstWhereOrNull(
      (final file) => file.name.contains(item.path),
    );

    if (file != null) {
      archiveFiles.add(file);
    }
  }
  return archiveFiles;
}
