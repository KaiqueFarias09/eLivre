import 'dart:typed_data';

const _EOCD_SIGNATURE = 0x06054b50;

class EpubFile {
  int signature = 0;
  int versionMadeBy = 0;
  int versionNeededToExtract = 0;
  int generalPurposeBitFlag = 0;
  int compressionMethod = 0;
  int lastModFileTime = 0;
  int lastModFileDate = 0;
  int crc32 = 0;
  int compressedSize = 0;
  int uncompressedSize = 0;
  int fileNameLength = 0;
  int extraFieldLength = 0;
  int fileCommentLength = 0;
  int diskNumberStart = 0;
  int internalFileAttributes = 0;
  int externalFileAttributes = 0;
  int relativeOffsetOfLocalHeader = 0;
  String fileName = '';
  Uint8List extraField = Uint8List(0);
  String fileComment = '';

  EpubFile.fromBytes(Uint8List bytes) {
    final data = ByteData.view(bytes.buffer);
    signature = data.getUint32(0, Endian.little);
    versionMadeBy = data.getUint16(4, Endian.little);
    versionNeededToExtract = data.getUint16(6, Endian.little);
    generalPurposeBitFlag = data.getUint16(8, Endian.little);
    compressionMethod = data.getUint16(10, Endian.little);
    lastModFileTime = data.getUint16(12, Endian.little);
    lastModFileDate = data.getUint16(14, Endian.little);
    crc32 = data.getUint32(16, Endian.little);
    compressedSize = data.getUint32(20, Endian.little);
    uncompressedSize = data.getUint32(24, Endian.little);
    fileNameLength = data.getUint16(28, Endian.little);
    extraFieldLength = data.getUint16(30, Endian.little);
    fileCommentLength = data.getUint16(32, Endian.little);
    diskNumberStart = data.getUint16(34, Endian.little);
    internalFileAttributes = data.getUint16(36, Endian.little);
    externalFileAttributes = data.getUint32(38, Endian.little);
    relativeOffsetOfLocalHeader = data.getUint32(42, Endian.little);
    fileName = String.fromCharCodes(bytes.sublist(46, 46 + fileNameLength));
    extraField = bytes.sublist(
      46 + fileNameLength,
      46 + fileNameLength + extraFieldLength,
    );
    fileComment = String.fromCharCodes(
      bytes.sublist(
        46 + fileNameLength + extraFieldLength,
        46 + fileNameLength + extraFieldLength + fileCommentLength,
      ),
    );
  }
}

List<EpubFile> parseLocalFileHeaders(Uint8List bytes) {
  // final headers = <ZipLocalFileHeader>[];
  // var offset = 0;
  // while (offset < bytes.length - 4) {
  //   final signature =
  //       ByteData.view(bytes.buffer).getUint32(offset, Endian.little);
  //   if (signature == 0x04034b50) {
  //     final header = ZipLocalFileHeader.fromBytes(bytes.sublist(offset));
  //     headers.add(header);
  //     offset += 30 +
  //         header.fileNameLength +
  //         header.extraFieldLength +
  //         header.compressedSize!;
  //   } else {
  //     offset += 1;
  //   }
  // }
  // return headers;

  final headers = <EpubFile>[];
  var offset = _findCentralDirectoryOffset(bytes);
  while (offset < bytes.length - 4) {
    final signature =
        ByteData.view(bytes.buffer).getUint32(offset, Endian.little);
    if (signature == 0x02014b50) {
      final header = EpubFile.fromBytes(bytes.sublist(offset));
      headers.add(header);
      offset += 46 +
          header.fileNameLength +
          header.extraFieldLength +
          header.fileCommentLength;
    } else {
      offset += 1;
    }
  }
  return headers;
}

int _findCentralDirectoryOffset(Uint8List bytes) {
  for (int i = bytes.lengthInBytes - 4; i >= 0; i--) {
    final buffer = bytes.buffer;

    final potentialSignature = buffer.asByteData().getUint32(i, Endian.little);
    if (potentialSignature == _EOCD_SIGNATURE) {
      final centralDirectoryOffset = buffer.asByteData().getUint32(
            i + 16,
            Endian.little,
          );
      return centralDirectoryOffset;
    }
  }

  throw Exception('EOCDR not found in zip file');
}
