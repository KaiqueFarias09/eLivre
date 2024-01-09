import 'package:liber_epub/core/entities/epub_package.dart';
import 'package:xml/xml.dart';

Package parsePackage(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final packageElement = document.findElements('package').first;

  final metadataElement = packageElement.findElements('metadata').first;
  final manifestElement = packageElement.findElements('manifest').first;
  final spineElement = packageElement.findElements('spine').first;
  final guideElement = packageElement.findElements('guide').first;

  final metadata = Metadata(
    rights: metadataElement.findElements('dc:rights').first.text,
    contributor: metadataElement.findElements('dc:contributor').first.text,
    creator: metadataElement.findElements('dc:creator').first.text,
    publisher: metadataElement.findElements('dc:publisher').first.text,
    title: metadataElement.findElements('dc:title').first.text,
    date: metadataElement.findElements('dc:date').first.text,
    language: metadataElement.findElements('dc:language').first.text,
  );

  final manifest = manifestElement.findElements('item').map((itemElement) {
    return Item(
      href: itemElement.getAttribute('href')!,
      id: itemElement.getAttribute('id')!,
      mediaType: itemElement.getAttribute('media-type')!,
    );
  }).toList();

  final spine = Spine(
    toc: spineElement.getAttribute('toc')!,
    item: spineElement
        .findElements('itemref')
        .map((itemrefElement) => itemrefElement.getAttribute('idref')!)
        .toList(),
  );

  final guide = Guide(
    references: guideElement.findElements('reference').map((referenceElement) {
      return Reference(
        href: referenceElement.getAttribute('href')!,
        title: referenceElement.getAttribute('title')!,
        type: referenceElement.getAttribute('type')!,
      );
    }).toList(),
  );

  return Package(
    xmlns: packageElement.getAttribute('xmlns')!,
    uniqueIdentifier: packageElement.getAttribute('unique-identifier')!,
    version: packageElement.getAttribute('version')!,
    metadata: metadata,
    manifest: manifest,
    spine: spine,
    guide: guide,
  );
}
