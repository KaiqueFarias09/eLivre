import 'package:collection/collection.dart';
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';
import 'package:e_livre/features/epub/entities/package/epub_3_package.dart';
import 'package:e_livre/features/epub/entities/package/epub_package.dart';
import 'package:xml/xml.dart';

/// Parses the provided XML string into an `EpubPackage`.
///
/// The function first parses the XML string into an XML document, then retrieves the package element from the document.
/// It then retrieves the version, metadata, manifest, and spine from the package element.
/// Depending on the version, it either creates an `Epub2Package` or an `Epub3Package` from the retrieved data.
///
/// [xmlString] is the XML string to parse.
///
/// Returns an `EpubPackage` representing the parsed package.
///
/// Throws an `Exception` if the TOC ID is empty when creating an `Epub3Package`.
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

  if (_isEpub2(version)) {
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
    final tocElement = manifestElement.findElements('item').firstWhereOrNull(
          (final element) =>
              element.getAttribute('properties')?.contains('nav') == true,
        );

    final tocPath = tocElement?.getAttribute('id') ?? spine.tocId;
    if (tocPath == null) {
      throw Exception('EPUB parsing package error: TOC ID is empty.');
    }

    return Epub3Package(
      xmlns: packageElement.getAttribute('xmlns'),
      uniqueIdentifier: packageElement.getAttribute('unique-identifier')!,
      version: packageElement.getAttribute('version')!,
      metadata: metadata,
      manifest: Epub2Manifest(items: manifestItems),
      spine: spine,
      tocId: tocPath,
    );
  }
}

Metadata _parseMetadata(
    final XmlElement metadataElement, final String version) {
  String getElementText(final String name) {
    final elements = metadataElement.findElements(name);
    return elements.isEmpty ? '' : elements.first.innerText.trim();
  }

  return _isEpub2(version)
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
    tocId: spineElement.getAttribute('toc'),
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

bool _isEpub2(final String version) => double.parse(version) < 3.0;
