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

  /// Is the text value of the element that has the unique identifier as 
  /// a property
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
