import 'package:liber_epub/features/epub/entities/epub_file_types.dart';

/// Represents the files contained in an EPUB document.
///
/// This class provides access to the images, CSS files, HTML files,
/// font files, and other files in the document.
class EpubFiles {
  /// Creates a new [EpubFiles] with the given lists of files.
  ///
  /// All parameters are required and must not be null.
  EpubFiles({
    required this.images,
    required this.css,
    required this.html,
    required this.fonts,
    required this.others,
  });

  /// The list of image files in the EPUB document.
  final List<BinaryEpubFile> images;

  /// The list of CSS files in the EPUB document.
  final List<TextEpubFile> css;

  /// The list of HTML files in the EPUB document.
  final List<TextEpubFile> html;

  /// The list of font files in the EPUB document.
  final List<BinaryEpubFile> fonts;

  /// The list of other files in the EPUB document.
  final List<BinaryEpubFile> others;

  @override
  String toString() {
    return 'EpubFiles(images: $images, cssFiles: $css, htmlFiles: $html, fontFiles: $fonts, otherFiles: $others)';
  }
}
