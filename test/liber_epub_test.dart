import 'dart:io';

import 'package:liber_epub/features/epub/entities/book/book.dart';
import 'package:liber_epub/features/epub/utils/read_book.dart';
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

      test(
        'should succeed',
        () async {
          int index = 0;
          final directory = Directory('test/resources');
          final files = directory.listSync();
          final books = files
              .where(
                (final book) => book.path.endsWith('.epub'),
              )
              .toList();

          try {
            final List<EpubBook> bookEntities = [];
            for (int i = 0; i < books.length; i++) {
              index = i;
              bookEntities.add(await readBook(books[i].path));
            }
            expect(bookEntities.length, files.length);
          } catch (exception) {
            fail(
                'Exception thrown at index $index, file: ${files[index].path}');
          }
        },
      );
    },
  );
}
