import 'dart:typed_data';

import 'package:e_livre/features/mobi/entities/palm_database_attribute.dart';

List<PalmDatabaseAttribute> getPalmDatabaseAttributes(
  final List<int> raw,
) {
  final attributes = {
    'Read Only': 0x02,
    'Dirty AppInfoArea': 0x04,
    'Backup this database': 0x08,
    'Okay to install newer over existing copy, if present on PalmPilot': 0x10,
    'Force the PalmPilot to reset after this database is installed': 0x12,
    "Don't allow copy of file to be beamed to other Pilot": 0x14,
  };

  final ByteData byteData = ByteData.view(Uint8List.fromList(raw).buffer);
  final val = byteData.getUint16(0, Endian.little);
  return attributes.entries.map((final entry) {
    return PalmDatabaseAttribute(
      name: entry.key,
      field: entry.value,
      val: val,
    );
  }).toList();
}
