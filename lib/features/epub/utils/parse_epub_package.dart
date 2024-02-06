import 'package:collection/collection.dart';
import 'package:e_livre/features/epub/entities/package/epub_2_package.dart';
import 'package:e_livre/features/epub/entities/package/epub_3_package.dart';
import 'package:e_livre/features/epub/entities/package/epub_package.dart';
import 'package:e_livre/features/epub/exceptions/epub_exception.dart';
import 'package:xml/xml.dart';

/// Parses the provided XML string into an `EpubPackage`.
///
/// The function first parses the XML string into an XML document, then retrieves the package element from the document.
/// It then retrieves the version, metadata, manifest, and spine from the package element.
/// Depending on the version, it either creates an `Epub2Package` or an `Epub3Package` from the retrieved data.
///
/// [xml] is the XML string to parse.
///
/// Returns an `EpubPackage` representing the parsed package.
///
/// Throws an `EpubException` if the TOC ID is empty when creating an `Epub3Package`.
EpubPackage parsePackage(final String xml) {
  final document = XmlDocument.parse(xml);
  final namespaceUri = document.rootElement.namespaceUri;

  final package = document
      .findElements(
        'package',
        namespace: namespaceUri,
      )
      .firstOrNull;
  _validate(package, 'package');
  final version = package!.getAttribute('version')?.trim() ?? '2.0';

  final metadataElement = package
      .findElements(
        'metadata',
        namespace: namespaceUri,
      )
      .firstOrNull;
  _validate(metadataElement, 'metadata');

  final manifestElement = package
      .findElements(
        'manifest',
        namespace: namespaceUri,
      )
      .firstOrNull;
  _validate(manifestElement, 'manifest');
  final spineElement = package
      .findElements(
        'spine',
        namespace: namespaceUri,
      )
      .firstOrNull;
  _validate(spineElement, 'spine');

  final uniqueIdentifierProperty = package.getAttribute(
        'unique-identifier',
      ) ??
      'uuid_id';

  final metadata = _parseMetadata(
    metadataElement!,
    version,
    uniqueIdentifierProperty,
  );
  final manifestItems = _parseManifestItems(manifestElement!, namespaceUri);
  final spine = _parseSpine(spineElement!);

  final xmlns = package.getAttribute('xmlns');
  if (_isEpub2(version)) {
    final guideElement = package
        .findElements(
          'guide',
          namespace: namespaceUri,
        )
        .firstOrNull;
    final guide = guideElement != null ? _parseGuide(guideElement) : null;

    return Epub2Package(
      xmlns: xmlns,
      uniqueIdentifier: uniqueIdentifierProperty,
      version: version,
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
      throw EpubException('EPUB parsing package error: TOC ID is empty.');
    }

    return Epub3Package(
      xmlns: xmlns,
      uniqueIdentifier: uniqueIdentifierProperty,
      version: version,
      metadata: metadata,
      manifest: Epub2Manifest(items: manifestItems),
      spine: spine,
      tocId: tocPath,
    );
  }
}

void _validate(final XmlElement? item, final String name) {
  if (item != null) return;
  throw EpubException('EPUB parsing package error: No $name element found.');
}

// XmlElement getCorrectPackage(final XmlDocument xml) {
//   XmlElement? packageElements = xml.findElements('package').firstOrNull;
//   if (packageElements != null) return packageElements;

//   packageElements = xml.findAllElements('ns0:package').firstOrNull;
//   if (packageElements != null) return packageElements;

//   throw EpubException('EPUB parsing package error: No package element found.');
// }

Metadata _parseMetadata(
  final XmlElement metadataElement,
  final String version,
  final String uniqueIdentifierProperty,
) {
  String getElementText(final String name) {
    final elements = metadataElement.findElements(name);
    return elements.isEmpty ? '' : elements.first.innerText.trim();
  }

  final rights = metadataElement
      .findElements('dc:rights')
      .map((final e) => e.innerText.trim())
      .toList();
  final contributor = getElementText('dc:contributor');
  final creator = getElementText('dc:creator');
  final date =
      metadataElement.findElements('dc:date').firstOrNull?.innerText.trim() ??
          (metadataElement
                  .findElements('meta')
                  .firstWhereOrNull(
                    (final element) =>
                        element.getAttribute('property') == 'dc:date',
                  )
                  ?.innerText
                  .trim() ??
              '');
  final publisher = metadataElement
          .findElements('dc:publisher')
          .firstOrNull
          ?.innerText
          .trim() ??
      (metadataElement
              .findElements('meta')
              .firstWhereOrNull(
                (final element) =>
                    element.getAttribute('property') == 'dc:publisher',
              )
              ?.innerText
              .trim() ??
          '');
  final language = getElementText('dc:language');

  final subjectText = getElementText('dc:subject');
  final subject = subjectText.isEmpty ? getElementText('dc:type') : subjectText;
  final description = getElementText('dc:description');
  final title = getElementText('dc:title');
  final identifiers = metadataElement
      .findElements('dc:identifier')
      .map((final e) => e.innerText.trim())
      .toList();

  final uniqueIdentifierValue = metadataElement
      .findElements('dc:identifier')
      .firstWhere(
        (final element) =>
            element.getAttribute('id') == uniqueIdentifierProperty,
      )
      .innerText
      .trim();

  if (_isEpub2(version)) {
    return Epub2Metadata(
      rights: rights,
      contributor: contributor,
      creator: creator,
      publisher: publisher,
      title: title,
      date: date,
      language: language,
      subject: subject,
      description: description,
      identifiers: identifiers,
      uniqueIdentifierValue: uniqueIdentifierValue,
    );
  }

  final educationalRole = metadataElement
      .findElements('meta')
      .firstWhere((final element) =>
          element.getAttribute('property') == 'schema:educationalRole')
      .innerText
      .trim();
  final typicalAgeRange = metadataElement
      .findElements('meta')
      .firstWhere((final element) =>
          element.getAttribute('property') == 'schema:typicalAgeRange')
      .innerText
      .trim();
  final accessibilityFeatures = metadataElement
      .findElements('meta')
      .where((final element) =>
          element.getAttribute('property') == 'schema:accessibilityFeature')
      .map((final e) => e.innerText.trim())
      .toList();

  return Epub3Metadata(
    rights: rights,
    contributor: contributor,
    creator: creator,
    publisher: publisher,
    title: title,
    date: date,
    language: language,
    subject: subject,
    description: description,
    identifiers: identifiers,
    schemaOrgs: metadataElement
        .findElements('meta')
        .where(
            (final element) => element.getAttribute('property') == 'schema:org')
        .map((final e) => e.innerText.trim())
        .toList(),
    accessibilitySummaries: metadataElement
        .findElements('meta')
        .where((final element) =>
            element.getAttribute('property') == 'a11y:summary')
        .map((final e) => e.innerText.trim())
        .toList(),
    educationalRole: educationalRole,
    typicalAgeRange: typicalAgeRange,
    accessibilityFeatures: accessibilityFeatures,
    uniqueIdentifierValue: uniqueIdentifierValue,
    modified: metadataElement
        .findElements('meta')
        .where((final element) =>
            element.getAttribute('property') == 'dcterms:modified')
        .first
        .innerText
        .trim(),
    rendition: metadataElement
            .findElements('meta')
            .firstWhereOrNull(
              (final element) =>
                  element.getAttribute('property') == 'rendition',
            )
            ?.innerText
            .trim() ??
        '',
    belongsToCollection: metadataElement
            .findElements('meta')
            .firstWhereOrNull((final element) =>
                element.getAttribute('property') == 'belongs-to-collection')
            ?.innerText
            .trim() ??
        '',
    sourceOf: metadataElement
            .findElements('meta')
            .firstWhereOrNull(
              (final element) =>
                  element.getAttribute('refines') == '#cover-image' &&
                  element.getAttribute('property') == 'source-of',
            )
            ?.innerText
            .trim() ??
        '',
    recordIdentifier: metadataElement
            .findElements('meta')
            .firstWhereOrNull(
              (final element) =>
                  element.getAttribute('property') ==
                  'dcterms:recordIdentifier',
            )
            ?.innerText
            .trim() ??
        '',
  );
}

List<ManifestItem> _parseManifestItems(
  final XmlElement manifestElement,
  final String? namespaceUri,
) {
  return manifestElement.findElements('item', namespace: namespaceUri).map((
    final itemElement,
  ) {
    return ManifestItem(
      path: itemElement.getAttribute('href')!,
      id: itemElement.getAttribute('id')!,
      mediaType: itemElement.getAttribute('media-type')!,
      properties:
          itemElement.getAttribute('properties')?.split(' ').toList() ?? [],
    );
  }).toList();
}

Spine _parseSpine(final XmlElement spineElement) {
  return Spine(
    tocId: spineElement.getAttribute('toc'),
    items: spineElement
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
