import 'package:liber_epub/features/epub/entities/epub_package.dart';
import 'package:xml/xml.dart';

EpubPackage parsePackage(final String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final packageElement = document.findElements('package').first;

  final metadataElement = packageElement.findElements('metadata').first;
  final manifestElement = packageElement.findElements('manifest').first;
  final spineElement = packageElement.findElements('spine').first;
  final guideElement = packageElement.findElements('guide').first;

  String getElementText(
    final String name,
  ) {
    final elements = metadataElement.findElements(name);
    return elements.isEmpty ? '' : elements.first.value ?? '';
  }

  final metadata = Metadata(
    rights: getElementText('dc:rights'),
    contributor: getElementText('dc:contributor'),
    creator: getElementText('dc:creator'),
    publisher: getElementText('dc:publisher'),
    title: getElementText('dc:title'),
    date: getElementText('dc:date'),
    language: getElementText('dc:language'),
    subject: getElementText('dc:subject'),
    description: getElementText('dc:description'),
    identifier: getElementText('dc:identifier'),
  );
  final manifestItems =
      manifestElement.findElements('item').map((final itemElement) {
    return ManifestItem(
      href: itemElement.getAttribute('href')!,
      id: itemElement.getAttribute('id')!,
      mediaType: itemElement.getAttribute('media-type')!,
      properties: itemElement.getAttribute('properties') ?? '',
    );
  }).toList();

  final spine = Spine(
    toc: spineElement.getAttribute('toc')!,
    item: spineElement
        .findElements('itemref')
        .map((final itemrefElement) => itemrefElement.getAttribute('idref')!)
        .toList(),
  );

  final guide = Guide(
    references:
        guideElement.findElements('reference').map((final referenceElement) {
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
    manifest: Manifest(items: manifestItems),
    spine: spine,
    guide: guide,
  );
}
