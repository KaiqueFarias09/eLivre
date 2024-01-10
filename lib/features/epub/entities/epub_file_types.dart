import 'dart:typed_data';

/// Represents a binary EPUB file.
///
/// This class extends [_EpubFile] and adds a [content] field
/// of type [Uint8List] to hold the binary content of the file.
class BinaryEpubFile extends _EpubFile {
  /// Creates a new [BinaryEpubFile].
  ///
  /// Requires [content], [name], [path], and [type] to be non-null.
  BinaryEpubFile({
    required this.content,
    required final String name,
    required final String type,
    required final String path,
  }) : super(name: name, type: type, path: path);

  /// Creates an empty [BinaryEpubFile].
  factory BinaryEpubFile.empty() {
    return BinaryEpubFile(
      content: Uint8List(0),
      name: '',
      type: '',
      path: '',
    );
  }

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
  /// Requires [content], [name], [path], and [type] to be non-null.
  TextEpubFile({
    required this.content,
    required final String name,
    required final String type,
    required final String path,
  }) : super(name: name, type: type, path: path);

  /// The text content of the EPUB file.
  final String content;
}

abstract class _EpubFile {
  _EpubFile({required this.name, required this.type, required this.path});

  final String name;
  final String type;
  final String path;
}
