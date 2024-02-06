import 'dart:io';

import 'package:e_livre/features/epub/entities/book/book.dart';
import 'package:e_livre/features/epub/exceptions/epub_exception.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Reader',
    () {
      test('should throw exception when path is empty', () async {
        const path = '';
        try {
          await EpubBook.fromFilePath(path);
          fail('EpubException not thrown');
        } on EpubException catch (exception) {
          expect(exception, isA<EpubException>());
          expect(exception.toString(), 'EpubException: Path cannot be empty');
        }
      });

      test('should throw exception when file does not exist', () async {
        const path = '/path/to/nonexistent/file.epub';
        try {
          await EpubBook.fromFilePath(path);
          fail('EpubException not thrown');
        } on EpubException catch (exception) {
          expect(exception, isA<EpubException>());
          expect(
              exception.toString(), 'EpubException: No such file or directory');
        }
      });

      final directory = Directory('test/resources/epub');
      final files = directory.listSync();
      final books = files.where((final book) {
        return book.path.endsWith('.epub');
      }).toList();

      for (final book in books) {
        test(
          'should succeed',
          () async {
            final bookEntity = await EpubBook.fromFilePath(book.path);
            expect(bookEntity, isA<EpubBook>());
          },
        );
      }
    },
  );
}
