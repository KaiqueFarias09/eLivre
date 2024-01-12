// Base classes
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';

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
  BaseMetadata metadata;
  BaseManifest manifest;
  Spine spine;
  String? xmlns;
  Guide? guide;
}

abstract class BaseMetadata {
  BaseMetadata({
    required this.title,
    required this.date,
    required this.language,
    required this.identifier,
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
  String identifier;
  String? subject;
  String? description;
  String? rights;
  String? contributor;
  String? creator;
  String? publisher;
}

abstract class BaseManifest {
  BaseManifest({required this.items});

  List<ManifestItem> items;
}
