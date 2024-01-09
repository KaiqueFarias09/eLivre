import 'package:liber_epub/core/entities/epub_package.dart';
import 'package:xml/xml.dart';

EpubPackage parsePackage(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final packageElement = document.findElements('package').first;

  final metadataElement = packageElement.findElements('metadata').first;
  final manifestElement = packageElement.findElements('manifest').first;
  final spineElement = packageElement.findElements('spine').first;
  final guideElement = packageElement.findElements('guide').first;

  String getElementText(XmlElement element, String name) {
    final elements = element.findElements(name);
    return elements.isEmpty ? '' : elements.first.value ?? '';
  }

  final metadata = Metadata(
    rights: getElementText(metadataElement, 'dc:rights'),
    contributor: getElementText(metadataElement, 'dc:contributor'),
    creator: getElementText(metadataElement, 'dc:creator'),
    publisher: getElementText(metadataElement, 'dc:publisher'),
    title: getElementText(metadataElement, 'dc:title'),
    date: getElementText(metadataElement, 'dc:date'),
    language: getElementText(metadataElement, 'dc:language'),
    subject: getElementText(metadataElement, 'dc:subject'),
    description: getElementText(metadataElement, 'dc:description'),
    identifier: getElementText(metadataElement, 'dc:identifier'),
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

  return EpubPackage(
    xmlns: packageElement.getAttribute('xmlns')!,
    uniqueIdentifier: packageElement.getAttribute('unique-identifier')!,
    version: packageElement.getAttribute('version')!,
    metadata: metadata,
    manifest: manifest,
    spine: spine,
    guide: guide,
  );
}
