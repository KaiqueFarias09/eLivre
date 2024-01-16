import 'dart:typed_data';

import 'package:e_livre/features/mobi/entities/palm_database.dart';
import 'package:e_livre/features/mobi/get_palm_database_attributes.dart';
import 'package:e_livre/features/mobi/utils/convert_bytes_to_int16.dart';
import 'package:e_livre/features/mobi/utils/convert_bytes_to_int32.dart';
import 'package:e_livre/features/mobi/utils/convert_bytes_to_string.dart';

PalmDatabase extractPalmDatabase(final Uint8List bytes) {
  final palmDatabase = bytes.sublist(0, 78);

  final type = convertBytesToString(palmDatabase.sublist(60, 64));
  final creator = convertBytesToString(palmDatabase.sublist(64, 68));
  final ident = type + creator;
  _validateIdent(ident);

  return PalmDatabase(
    attributes: getPalmDatabaseAttributes(palmDatabase.sublist(32, 34)),
    appInfoId: convertBytesToString(palmDatabase.sublist(52, 56)),
    sortInfoId: convertBytesToString(palmDatabase.sublist(56, 60)),
    databaseName: convertBytesToString(palmDatabase.sublist(0, 32)),
    type: type,
    creator: creator,
    ident: ident,
    uniqueIdSeed: convertBytesToInt32(palmDatabase.sublist(68, 72)),
    nextRecordListId: convertBytesToInt32(palmDatabase.sublist(72, 76)),
    numberOfRecords: convertBytesToInt16(palmDatabase.sublist(76, 78)),
  );
}

void _validateIdent(final String ident) {
  final possibleIdents = ['BOOKMOBI', 'TEXTREAD'];
  if (!possibleIdents.contains(ident)) throw Exception('Not a MOBI file');
}
