import 'dart:typed_data';

import 'package:liber_epub/features/epub/entities/file/epub_file.dart';

/// Represents a binary EPUB file.
///
/// This class extends [EpubFile] and adds a [content] field
/// of type [Uint8List] to hold the binary content of the file.
class BinaryFile extends EpubFile {
  /// Creates a new [BinaryFile].
  ///
  /// Requires [content], [name], [path], and [type] to be non-null.
  BinaryFile({
    required this.content,
    required final String name,
    required final String type,
    required final String path,
  }) : super(name: name, type: type, path: path);

  /// Creates an empty [BinaryFile].
  factory BinaryFile.empty() {
    return BinaryFile(
      content: Uint8List(0),
      name: '',
      type: '',
      path: '',
    );
  }

  /// Returns `true` if the binary file is empty, `false` otherwise.
  bool get isEmpty => content.isEmpty;

  /// The binary content of the EPUB file.
  final Uint8List content;
}
