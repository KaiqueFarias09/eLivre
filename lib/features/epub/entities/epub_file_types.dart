import 'dart:typed_data';

/// Represents a binary EPUB file.
///
/// This class extends [_EpubFile] and adds a [content] field
/// of type [Uint8List] to hold the binary content of the file.
class BinaryEpubFile extends _EpubFile {
  /// Creates a new [BinaryEpubFile].
  ///
  /// Requires [content], [name], and [type] to be non-null.
  BinaryEpubFile({
    required this.content,
    required final String name,
    required final String type,
  }) : super(name: name, type: type);

  /// The binary content of the EPUB file.
  final Uint8List content;
}

/// Represents a text EPUB file.
///
/// This class extends [_EpubFile] and adds a [content] field
/// of type [String] to hold the text content of the file.
class TextEpubFile extends _EpubFile {
  /// Creates a new [TextEpubFile].
  ///
  /// Requires [content], [name], and [type] to be non-null.
  TextEpubFile({
    required this.content,
    required final String name,
    required final String type,
  }) : super(name: name, type: type);

  /// The text content of the EPUB file.
  final String content;
}

abstract class _EpubFile {
  _EpubFile({required this.name, required this.type});

  final String name;
  final String type;
}
