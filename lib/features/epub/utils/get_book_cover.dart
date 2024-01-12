import 'package:collection/collection.dart';
import 'package:e_livre/features/epub/entities/file/binary_file.dart';
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';

/// Retrieves the cover of the book from the provided manifest items and images.
///
/// The function first tries to find a manifest item with the property 'cover-image' or an id containing 'cover'.
/// If such an item is found, it then tries to find an image with a path that contains the path of the cover item.
/// If no cover item or corresponding image is found, it returns an empty `BinaryFile`.
///
/// [manifestItems] is the list of manifest items to search for the cover item.
/// [images] is the list of images to search for the cover image.
///
/// Returns a `BinaryFile` representing the cover of the book.
BinaryFile getBookCover(
  final List<ManifestItem> manifestItems,
  final List<BinaryFile> images,
) {
  final ManifestItem? coverItem = manifestItems.firstWhereOrNull(
    (final item) {
      return item.properties == 'cover-image' || item.id.contains('cover');
    },
  );

  return coverItem == null
      ? BinaryFile.empty()
      : images.firstWhere(
          (final image) => image.path.contains(coverItem.path),
          orElse: BinaryFile.empty,
        );
}
