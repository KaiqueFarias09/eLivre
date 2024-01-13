import 'package:e_livre/e_livre.dart' as livre;

void main() async {
  final book = await livre.readBook('test/resources/linear-algebra.epub');

  print(book.package.metadata.title);
  print(book.package.metadata.creator);
  print(book.package.metadata.language);
  print(book.package.metadata.subject);
}
