import 'dart:convert' as convert;

import 'package:archive/archive.dart';
import 'package:liber_epub/features/epub/entities/epub_navigation.dart';
import 'package:liber_epub/features/epub/entities/epub_package.dart';
import 'package:xml/xml.dart';

EpubNavigation processPackage(
  final EpubPackage package,
  final Archive archive,
  final String? rootFilePath,
) {
  // TODO: Add support for EPUB 3.0
  if (package.version == '2.0') {
    final tocId = package.spine.toc;
    if (tocId.isEmpty) {
      throw Exception('EPUB parsing error: TOC ID is empty.');
    }

    final tocManifestItem = package.manifest.items.firstWhere(
      (final element) => element.id == tocId,
      orElse: () => throw Exception(
          'EPUB parsing error: TOC item $tocId not found in EPUB manifest.'),
    );

    final contentDirectoryPath = _getDirectoryPath(rootFilePath ?? '');
    final tocFileEntryPath = _combinePaths(
      contentDirectoryPath,
      tocManifestItem.href,
    );

    final tocFileEntry = archive.files.firstWhere(
      (final file) => file.name.toLowerCase() == tocFileEntryPath.toLowerCase(),
      orElse: () => throw Exception(
        'EPUB parsing error: TOC file $tocFileEntryPath not found in archive.',
      ),
    );

    final containerDocument = XmlDocument.parse(
      convert.utf8.decode(tocFileEntry.content as List<int>),
    );
    final navigationContent = EpubNavigation(document: containerDocument);
    return navigationContent;
  } else {
    throw Exception('EPUB parsing error: Unsupported EPUB version.');
  }
}

String _combinePaths(
  final String directory,
  final String fileName,
) {
  return directory == '' ? fileName : '$directory/$fileName';
}

String _getDirectoryPath(final String filePath) {
  final lastSlashIndex = filePath.lastIndexOf('/');
  return lastSlashIndex == -1 ? '' : filePath.substring(0, lastSlashIndex);
}
