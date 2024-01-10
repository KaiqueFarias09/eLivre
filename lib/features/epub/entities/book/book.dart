import 'package:liber_epub/features/epub/entities/book/files.dart';
import 'package:liber_epub/features/epub/entities/file/binary_file.dart';
import 'package:liber_epub/features/epub/entities/navigation/navigation.dart';
import 'package:liber_epub/features/epub/entities/package/epub_package.dart';

class EpubBook {
  EpubBook({
    required this.navigation,
    required this.files,
    required this.cover,
    required this.package,
  });

  final Navigation navigation;
  final Files files;
  final BinaryFile cover;
  final EpubPackage package;
}
