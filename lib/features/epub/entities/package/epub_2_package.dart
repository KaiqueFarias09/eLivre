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
    required super.identifier,
  });

  @override
  String toString() {
    return 'Metadata(rights: $rights, contributor: $contributor, creator: $creator, publisher: $publisher, title: $title, date: $date, language: $language, subject: $subject, description: $description, identifier: $identifier)';
  }
}

class ManifestItem {
  ManifestItem({
    required this.path,
    required this.id,
    required this.mediaType,
    this.properties = '',
  });

  String path;
  String id;
  String mediaType;
  String properties;

  @override
  String toString() {
    return 'Item(href: $path, id: $id, mediaType: $mediaType)';
  }
}

class Spine {
  Spine({
    required this.tocId,
    required this.item,
  });

  String? tocId;
  List<String> item;

  @override
  String toString() {
    return 'Spine(toc: $tocId, item: $item)';
  }
}

class Guide {
  Guide({
    required this.references,
  });

  List<Reference> references;

  @override
  String toString() {
    return 'Guide(references: $references)';
  }
}

class Reference {
  Reference({
    required this.href,
    required this.title,
    required this.type,
  });

  String href;
  String title;
  String type;

  @override
  String toString() {
    return 'Reference(href: $href, title: $title, type: $type)';
  }
}
