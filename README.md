# eLivre

This is a Dart package for handling ebook files in EPUB 2.0 and 3.0 formats.

## Features

-   Read EPUB 2.0 and EPUB 3.0 files
-   Navigate through the book structure
-   Extract book metadata
-   Extract book files

## Getting Started

To use this package, add `e_livre` as a dependency in your `pubspec.yaml` file.

```dartx
dependencies:
  e_livre: ^2.0.0
```

Then, run `flutter pub get` in your terminal.

## Usage

Here's a basic example app: \
![anim](https://github.com/KaiqueFarias09/eLivre/assets/86803230/d8e472c4-3032-4fde-ae2c-dbf43dc70afe)


## Example code
```dart
import 'package:e_livre/e_livre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Future<EpubBook> loadAsset() async {
    final bytes = rootBundle.load(
      'assets/Alices Adventures in Wonderland.epub',
    );
    return EpubBook.fromBytes(Uint8List.sublistView(await bytes));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[900],
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,![anim](https://github.com/KaiqueFarias09/eLivre/assets/86803230/68bdba7a-5316-4518-8e1b-8efb323f4a91)

      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: FutureBuilder(
          future: loadAsset(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final book = snapshot.data as EpubBook;
              final images = book.images;

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.memory(
                      images[4].content,
                      width: MediaQuery.of(context).size.width * 0.75,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      book.creator ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Reader(book: book, images: images);
                              },
                            ),
                          );
                        },
                        child: const Text('Read now'),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Reader extends StatelessWidget {
  const Reader({
    super.key,
    required this.book,
    required this.images,
  });

  final EpubBook book;
  final List<BinaryFile> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        titleSpacing: 0,
        backgroundColor: Colors.grey[900],
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: book.content.length,
        itemBuilder: (context, index) {
          final file = book.content[index];
          return Html(
            data: file.content,
            style: {
              'html': Style(
                backgroundColor: Colors.grey[900],
                color: Colors.white,
                fontSize: FontSize(16),
              ),
            },
            extensions: [
              TagExtension(
                tagsToExtend: {'img'},
                builder: (el) {
                  final src = el.attributes['src'];
                  if (src == null) {
                    return const SizedBox();
                  }
                  final image = images.firstWhere(
                    (e) => e.path.contains(src),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(child: Image.memory(image.content)),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
```



