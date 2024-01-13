// Base classes

abstract class EpubPackage {
  EpubPackage({
    required this.version,
    required this.metadata,
    required this.manifest,
    required this.spine,
    required this.uniqueIdentifier,
    this.guide,
    this.xmlns,
  });

  String uniqueIdentifier;
  String version;
  Metadata metadata;
  Manifest manifest;
  Spine spine;
  String? xmlns;
  Guide? guide;
}

abstract class Metadata {
  Metadata({
    required this.title,
    required this.date,
    required this.language,
    required this.identifiers,
    required this.uniqueIdentifierValue,
    this.rights,
    this.contributor,
    this.creator,
    this.publisher,
    this.subject,
    this.description,
  });

  String title;
  String date;
  String language;
  List<String> identifiers;
  String uniqueIdentifierValue;
  String? subject;
  String? description;
  List<String>? rights;
  String? contributor;
  String? creator;
  String? publisher;
}

abstract class Manifest {
  Manifest({required this.items});

  List<ManifestItem> items;
}

class ManifestItem {
  ManifestItem({
    required this.path,
    required this.id,
    required this.mediaType,
    this.properties = const [],
  });

  String path;
  String id;
  String mediaType;
  List<String> properties;

  @override
  String toString() {
    return 'Item(href: $path, id: $id, mediaType: $mediaType)';
  }
}

class Spine {
  Spine({
    required this.tocId,
    required this.items,
  });

  String? tocId;
  List<String> items;

  @override
  String toString() {
    return 'Spine(toc: $tocId, item: $items)';
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
