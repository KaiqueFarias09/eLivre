import 'dart:io';

import 'package:e_livre/features/epub/entities/book/book.dart';
import 'package:e_livre/features/epub/utils/read_book.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Reader',
    () {
      test('should throw exception when path is empty', () async {
        const path = '';
        try {
          await readBook(path);
          fail('Exception not thrown');
        } catch (exception) {
          expect(exception, isA<Exception>());
          expect(exception.toString(), 'Exception: Path cannot be empty');
        }
      });

      test('should throw exception when file does not exist', () async {
        const path = '/path/to/nonexistent/file.epub';
        try {
          await readBook(path);
          fail('Exception not thrown');
        } catch (exception) {
          expect(exception, isA<Exception>());
          expect(exception.toString(), 'Exception: No such file or directory');
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
            final EpubBook bookEntity = await readBook(book.path);
            expect(bookEntity, isA<EpubBook>());
          },
        );
      }
    },
  );
}
