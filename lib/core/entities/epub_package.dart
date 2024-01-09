class EpubPackage {
  EpubPackage({
    required this.xmlns,
    required this.uniqueIdentifier,
    required this.version,
    required this.metadata,
    required this.manifest,
    required this.spine,
    required this.guide,
  });

  String xmlns;
  String uniqueIdentifier;
  String version;
  Metadata metadata;
  List<Item> manifest;
  Spine spine;
  Guide guide;

  @override
  String toString() {
    return 'Package(xmlns: $xmlns, uniqueIdentifier: $uniqueIdentifier, version: $version, metadata: $metadata, manifest: $manifest, spine: $spine, guide: $guide)';
  }
}

class Metadata {
  Metadata({
    required this.rights,
    required this.contributor,
    required this.creator,
    required this.publisher,
    required this.title,
    required this.date,
    required this.language,
    required this.subject,
    required this.description,
    required this.identifier,
  });

  String rights;
  String contributor;
  String creator;
  String publisher;
  String title;
  String date;
  String language;
  String subject;
  String description;
  String identifier;

  @override
  String toString() {
    return 'Metadata(rights: $rights, contributor: $contributor, creator: $creator, publisher: $publisher, title: $title, date: $date, language: $language, subject: $subject, description: $description, identifier: $identifier)';
  }
}

class Item {
  Item({
    required this.href,
    required this.id,
    required this.mediaType,
  });

  String href;
  String id;
  String mediaType;

  @override
  String toString() {
    return 'Item(href: $href, id: $id, mediaType: $mediaType)';
  }
}

class Spine {
  Spine({
    required this.toc,
    required this.item,
  });

  String toc;
  List<String> item;

  @override
  String toString() {
    return 'Spine(toc: $toc, item: $item)';
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
