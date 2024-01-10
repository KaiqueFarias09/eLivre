import 'package:liber_epub/features/epub/entities/file/epub_file.dart';

/// Represents a text EPUB file.
///
/// This class extends [EpubFile] and adds a [content] field
/// of type [String] to hold the text content of the file.
class TextFile extends EpubFile {
  /// Creates a new [TextFile].
  ///
  /// Requires [content], [name], [path], and [type] to be non-null.
  TextFile({
    required this.content,
    required final String name,
    required final String type,
    required final String path,
  }) : super(name: name, type: type, path: path);

  /// The text content of the EPUB file.
  final String content;
}
