import 'package:collection/collection.dart';
import 'package:liber_epub/features/epub/entities/epub_file_types.dart';
import 'package:liber_epub/features/epub/entities/epub_package.dart';
import 'package:path/path.dart' as path;

BinaryEpubFile getBookCover(
  final List<ManifestItem> manifestItems,
  final List<BinaryEpubFile> images,
) {
  final ManifestItem? coverItem = manifestItems.firstWhereOrNull(
    (final item) {
      return item.properties == 'cover-image' || item.id.contains('cover');
    },
  );

  return coverItem == null
      ? BinaryEpubFile.empty()
      : images.firstWhere(
          (final image) => path.basename(coverItem.href) == image.name,
        );
}
