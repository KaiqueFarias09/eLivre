import 'package:liber_epub/liber_ebooks.dart';

class Epub3Package extends EpubPackage {
  Epub3Package({
    required super.version,
    required super.metadata,
    required super.manifest,
    required super.spine,
    required super.uniqueIdentifier,
    required super.xmlns,
    required this.tocId,
  });

  /// tocPath is present on some EPUB 3.0 books where instead of defining the
  /// toc in the spine it is defined in the manifest directly
  final String? tocId;
}

class Epub3Metadata extends BaseMetadata {
  Epub3Metadata({
    required super.rights,
    required super.contributor,
    required super.creator,
    required super.publisher,
    required super.title,
    required super.date,
    required super.language,
    required super.subject,
    required super.description,
    required super.identifier,
    required this.schemaOrg,
    required this.accessibilitySummary,
  });

  // EPUB 3.0 specific properties
  String schemaOrg;
  String accessibilitySummary;
}

class Epub3Manifest extends BaseManifest {
  Epub3Manifest({
    required super.items,
    required this.properties,
  });

  // EPUB 3.0 specific properties
  final String properties;
}
