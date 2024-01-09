import 'package:liber_epub/liber_ebooks.dart';
import 'package:test/test.dart';

void main() {
  group("Reader", () {
    test('should throw exception when path is empty', () async {
      const path = '';
      try {
        await Reader.decompressEpub(path);
        fail('Exception not thrown');
      } catch (exception) {
        expect(exception, isA<Exception>());
        expect(exception.toString(), 'Exception: Path cannot be empty');
      }
    });

    test('should throw exception when file does not exist', () async {
      const path = '/path/to/nonexistent/file.epub';
      try {
        await Reader.decompressEpub(path);
        fail('Exception not thrown');
      } catch (exception) {
        expect(exception, isA<Exception>());
        expect(exception.toString(), 'Exception: No such file or directory');
      }
    });

    test('should print the decompressed EPUB archive', () async {
      const path =
          'test/rsc/Harry_Potter_and_the_Chamber_of_Secrets_Harry_Potter_2.epub';
      final result = await Reader.decompressEpub(path);
      expect(result, isNull);
    });
  });
}
