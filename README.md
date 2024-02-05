# eLivre

This is a Dart package for handling ebook files in EPUB 2.0 and 3.0 formats.

## Features

-   Read EPUB 2.0 and EPUB 3.0 files
-   Navigate through the book structure
-   Extract book metadata
-   Extract book files

## Getting Started

To use this package, add `e_livre` as a dependency in your `pubspec.yaml` file.

```dart
dependencies:
  e_livre: ^1.0.3
```

Then, run `flutter pub get` in your terminal.

## Usage

Here's a basic example of how to use the package:

```dart
import 'package:e_livre/e_livre.dart' as livre;

void main() async {
  final book = await livre.readBook('test/resources/epub/linear-algebra.epub');

  print(book.package.metadata.title);
  print(book.package.metadata.creator);
  print(book.package.metadata.language);
}
```
