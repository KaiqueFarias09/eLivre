import 'package:collection/collection.dart';
import 'package:liber_epub/features/epub/entities/file/binary_file.dart';
import 'package:liber_epub/features/epub/entities/package/epub_2_package.dart';

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
