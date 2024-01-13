import 'package:e_livre/features/epub/entities/package/epub_package.dart';

class Epub2Package extends EpubPackage {
  Epub2Package({
    required super.version,
    required super.metadata,
    required super.manifest,
    required super.spine,
    required super.guide,
    required super.uniqueIdentifier,
    required super.xmlns,
  });

  @override
  String toString() {
    return 'Package(xmlns: $xmlns, uniqueIdentifier: $uniqueIdentifier, version: $version, metadata: $metadata, manifest: $manifest, spine: $spine, guide: $guide)';
  }
}

class Epub2Manifest extends Manifest {
  Epub2Manifest({required super.items});
}

class Epub2Metadata extends Metadata {
  Epub2Metadata({
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
  });

  @override
  String toString() {
    return 'Metadata(rights: $rights, contributor: $contributor, creator: $creator, publisher: $publisher, title: $title, date: $date, language: $language, subject: $subject, description: $description, identifier: $identifiers)';
  }
}
