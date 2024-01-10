import 'package:liber_epub/features/epub/entities/package/epub_package.dart';

class Epub3Package extends EpubPackage {
  Epub3Package({
    required super.version,
    required super.metadata,
    required super.manifest,
    required super.spine,
    required super.uniqueIdentifier,
    required super.xmlns,
  });
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
  String properties;
}
