import 'package:e_livre/e_livre.dart';

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

  // On some EPUB 3.0 files the tocPath is present directly on the manifest
  // element, but in others it is defined in the spine element instead
  final String? tocId;
}

class Epub3Metadata extends Metadata {
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
    required super.identifiers,
    required super.uniqueIdentifierValue,
    required this.schemaOrgs,
    required this.accessibilitySummaries,
    required this.educationalRole,
    required this.typicalAgeRange,
    required this.accessibilityFeatures,
  });

  List<String> schemaOrgs;
  List<String> accessibilitySummaries;
  List<String> accessibilityFeatures;
  String educationalRole;
  String typicalAgeRange;
}

class Epub3Manifest extends Manifest {
  Epub3Manifest({
    required super.items,
    required this.properties,
  });

  final String properties;
}
