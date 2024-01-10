import 'package:liber_epub/features/epub/entities/package/epub_2_package.dart';
import 'package:liber_epub/features/epub/entities/package/epub_3_package.dart';
import 'package:liber_epub/features/epub/entities/package/epub_package.dart';
import 'package:xml/xml.dart';

EpubPackage parsePackage(final String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final packageElement = document.findElements('package').first;

  final version = packageElement.getAttribute('version')!;
  final metadataElement = packageElement.findElements('metadata').first;
  final manifestElement = packageElement.findElements('manifest').first;
  final spineElement = packageElement.findElements('spine').first;

  final metadata = _parseMetadata(metadataElement, version);
  final manifestItems = _parseManifestItems(manifestElement);
  final spine = _parseSpine(spineElement);

  if (version != '2.0') {
    final guideElement = packageElement.findElements('guide').firstOrNull;
    final guide = guideElement != null ? _parseGuide(guideElement) : null;

    return Epub2Package(
      xmlns: packageElement.getAttribute('xmlns'),
      uniqueIdentifier: packageElement.getAttribute('unique-identifier')!,
      version: packageElement.getAttribute('version')!,
      metadata: metadata,
      manifest: Epub2Manifest(items: manifestItems),
      spine: spine,
      guide: guide,
    );
  } else {
    return Epub3Package(
      xmlns: packageElement.getAttribute('xmlns'),
      uniqueIdentifier: packageElement.getAttribute('unique-identifier')!,
      version: packageElement.getAttribute('version')!,
      metadata: metadata,
      manifest: Epub2Manifest(items: manifestItems),
      spine: spine,
    );
  }
}

BaseMetadata _parseMetadata(
    final XmlElement metadataElement, final String version) {
  String getElementText(final String name) {
    final elements = metadataElement.findElements(name);
    return elements.isEmpty ? '' : elements.first.value ?? '';
  }

  return version != '2.0'
      ? Epub2Metadata(
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
        )
      : Epub3Metadata(
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
          schemaOrg: getElementText('schema:org'),
          accessibilitySummary: getElementText('a11y:summary'),
        );
}

List<ManifestItem> _parseManifestItems(final XmlElement manifestElement) {
  return manifestElement.findElements('item').map((final itemElement) {
    return ManifestItem(
      path: itemElement.getAttribute('href')!,
      id: itemElement.getAttribute('id')!,
      mediaType: itemElement.getAttribute('media-type')!,
      properties: itemElement.getAttribute('properties') ?? '',
    );
  }).toList();
}

Spine _parseSpine(final XmlElement spineElement) {
  return Spine(
    toc: spineElement.getAttribute('toc')!,
    item: spineElement
        .findElements('itemref')
        .map((final itemrefElement) => itemrefElement.getAttribute('idref')!)
        .toList(),
  );
}

Guide? _parseGuide(final XmlElement guideElement) {
  return Guide(
    references:
        guideElement.findElements('reference').map((final referenceElement) {
      return Reference(
        href: referenceElement.getAttribute('href')!,
        title: referenceElement.getAttribute('title')!,
        type: referenceElement.getAttribute('type')!,
      );
    }).toList(),
  );
}
