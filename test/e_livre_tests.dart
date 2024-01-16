library e_livre_tests;

import 'tests/epub/open_book_test.dart' as open_book_test;
import 'tests/epub/package_parsing_test.dart' as package_parsing_test;

void main() {
  open_book_test.main();
  package_parsing_test.main();
}
