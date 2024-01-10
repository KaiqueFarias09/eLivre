import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:liber_epub/features/epub/entities/epub_file_types.dart';
import 'package:liber_epub/features/epub/entities/epub_files.dart';
import 'package:liber_epub/features/epub/entities/epub_package.dart';
import 'package:path/path.dart' as path;

/// Extracts various files from an EPUB archive.
class EpubFileExtractor {
  /// Executes the EPUB file extraction process.
  ///
  /// Returns an [EpubFiles] object containing the extracted files.
  EpubFiles execute(
    final Archive archive,
    final EpubPackage package,
  ) {
    return EpubFiles(
      images: _getImages(archive, package),
      css: _getCSSFiles(archive, package),
      html: _getHTMLFiles(archive, package),
      fonts: _getFontFiles(archive, package),
      others: _getOtherFiles(archive, package),
    );
  }
}

List<BinaryEpubFile> _getImages(
  final Archive archive,
  final EpubPackage package,
) {
  final imageItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('image/'),
  );

  final imageFiles = imageItems
      .map((final item) => archive.findFile(item.href))
      .where((final file) => file != null)
      .toList();

  return imageFiles
      .map(
        (final image) => BinaryEpubFile(
          name: path.basename(image!.name),
          type: image.name.split('.').last,
          content: Uint8List.fromList(image.content as List<int>),
        ),
      )
      .toList();
}

List<TextEpubFile> _getCSSFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final cssItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('text/css'),
  );
  return cssItems.map((final item) {
    final file = archive.findFile(item.href);
    return TextEpubFile(
      content: convert.utf8.decode(file!.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<TextEpubFile> _getHTMLFiles(
  final Archive archive,
  final EpubPackage package,
) {
  final htmlItems = package.manifest.items.where(
    (final item) => item.mediaType.contains('application/xhtml+xml'),
  );
  final htmlFiles = _getFilesFromItems(archive, htmlItems);
  return htmlFiles.map((final file) {
    return TextEpubFile(
      content: convert.utf8.decode(file.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<BinaryEpubFile> _getFontFiles(
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
    return BinaryEpubFile(
      content: Uint8List.fromList(file.content as List<int>),
      name: path.basename(file.name),
      type: file.name.split('.').last,
    );
  }).toList();
}

List<BinaryEpubFile> _getOtherFiles(
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
      return BinaryEpubFile(
        content: Uint8List.fromList(file.content as List<int>),
        name: path.basename(file.name),
        type: file.name.split('.').last,
      );
    },
  ).toList();
}

List<ArchiveFile> _getFilesFromItems(
  final Archive archive,
  final Iterable<ManifestItem> items,
) {
  return items
      .map((final item) => archive.findFile(item.href))
      .where((final file) => file != null)
      .cast<ArchiveFile>()
      .toList();
}
