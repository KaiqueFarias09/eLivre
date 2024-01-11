import 'dart:convert' as convert;

import 'package:archive/archive.dart';
import 'package:liber_epub/liber_ebooks.dart';
import 'package:xml/xml.dart';

Navigation getEpubNavigation(
  final EpubPackage package,
  final Archive archive,
  final String? rootFilePath,
) {
  final tocId = package is Epub3Package && package.spine.tocId == null
      ? package.tocId
      : package.spine.tocId;

  if (tocId == null) throw Exception('EPUB parsing error: TOC ID is empty.');

  final tocManifestItem = package.manifest.items.firstWhere(
    (final element) => element.id == tocId,
    orElse: () => throw Exception(
      'EPUB parsing error: TOC item $tocId not found in EPUB manifest.',
    ),
  );

  final contentDirectoryPath = _getDirectoryPath(rootFilePath ?? '');
  final tocFileEntryPath = _combinePaths(
    contentDirectoryPath,
    tocManifestItem.path,
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
  final navigationContent = Navigation(document: containerDocument);
  return navigationContent;
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
