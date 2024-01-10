import 'dart:io';

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
          try {
            final directory = Directory('test/resources');
            final files = directory.listSync();

            for (final file in files) {
              if (file is File && file.path.endsWith('.epub')) {
                await readBook(file.path);
              }
            }
          } catch (exception) {
            fail('Exception thrown');
          }
        },
      );
    },
  );
}
