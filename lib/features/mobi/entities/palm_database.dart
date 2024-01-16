import 'package:e_livre/features/mobi/entities/palm_database_attribute.dart';

class PalmDatabase {
  PalmDatabase(
      {required this.attributes,
      required this.appInfoId,
      required this.sortInfoId,
      required this.databaseName,
      required this.type,
      required this.creator,
      required this.uniqueIdSeed,
      required this.nextRecordListId,
      required this.numberOfRecords,
      required this.ident});

  /// Bit field. See [PalmDatabaseAttribute] for more information
  final List<PalmDatabaseAttribute> attributes;

  /// Offset to start of Application Info (if present) or empty string
  final String appInfoId;

  /// Offset to start of Sort Info (if present) or empty string
  final String sortInfoId;

  /// Usually is the name of the file
  final String databaseName;

  /// Identify the type of the database
  final String type;

  /// Usually set to 'MOBI', is the program that will be launched when the file
  /// is pressed
  final String creator;

  /// Used internally to identify record
  final int uniqueIdSeed;

  /// Only used when in-memory on Palm OS. Always set to zero in stored files.
  final int nextRecordListId;

  final String ident;

  final int numberOfRecords;

  @override
  String toString() {
    return 'PalmDatabase(attributes: $attributes, appInfoId: $appInfoId, sortInfoId: $sortInfoId, databaseName: $databaseName, type: $type, creator: $creator, uniqueIdSeed: $uniqueIdSeed, nextRecordListId: $nextRecordListId, ident: $ident, numberOfRecords: $numberOfRecords)';
  }
}
