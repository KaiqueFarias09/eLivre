import 'package:e_livre/features/epub/entities/file/epub_file.dart';

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
    required super.name,
    required super.type,
    required super.path,
  });

  /// The text content of the EPUB file.
  final String content;
}
