import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:liber_epub/liber_epub.dart';

void main() {
  test('decompressZip returns correct decompressed data', () async {
    const path =
        'test/rsc/Harry_Potter_and_the_Chamber_of_Secrets_Harry_Potter_2.epub';
    const password = 'password';

    final decompressedData = await Reader.decompressEpub(path, password);

    expect(decompressedData, isA<ByteBuffer>());
    // TODO: Add more assertions to validate the decompressed data
  });

  test('decompressZip throws exception when path is empty', () async {
    const path = '';
    const password = 'password';

    try {
      await Reader.decompressEpub(path, password);
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e, isException);
      expect(e.toString(), contains('Path cannot be empty'));
    }
  });

  test('decompressZip throws exception when zip file does not exist', () async {
    const path = '/path/to/nonexistent/file.zip';
    const password = 'password';

    try {
      await Reader.decompressEpub(path, password);
      fail('Expected an exception to be thrown');
    } catch (e) {
      expect(e, isException);
      expect(e.toString(), contains('No such file or directory'));
    }
  });
}
