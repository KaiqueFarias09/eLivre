import 'package:e_livre/features/epub/entities/file/binary_file.dart';
import 'package:e_livre/features/epub/entities/file/text_file.dart';

/// Represents the files contained in an EPUB document.
///
/// This class provides access to the images, CSS files, HTML files,
/// font files, and other files in the document.
class Files {
  /// Creates a new [Files] with the given lists of files.
  ///
  /// All parameters are required and must not be null.
  Files({
    required this.images,
    required this.css,
    required this.html,
    required this.fonts,
    required this.others,
  });

  /// The list of image files in the EPUB document.
  final List<BinaryFile> images;

  /// The list of CSS files in the EPUB document.
  final List<TextFile> css;

  /// The list of HTML files in the EPUB document.
  final List<TextFile> html;

  /// The list of font files in the EPUB document.
  final List<BinaryFile> fonts;

  /// The list of other files in the EPUB document.
  final List<BinaryFile> others;

  @override
  String toString() {
    return 'EpubFiles(images: $images, cssFiles: $css, htmlFiles: $html, fontFiles: $fonts, otherFiles: $others)';
  }
}
