import 'dart:convert' as convert;
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:e_livre/features/epub/entities/entities.dart';
import 'package:e_livre/features/epub/utils/get_epub_root_file_path.dart';
import 'package:e_livre/features/epub/utils/parse_epub_package.dart';
import 'package:test/test.dart';

void main() {
  final books = [
    _TestBookPackageInfo(
      file: 'test/resources/epub/Alices Adventures in Wonderland.epub',
      uniqueIdentifier: 'uuid_id',
      version: '2.0',
      title: "Alice's Adventures in Wonderland",
      date: '1865-07-04T00:00:00+00:00',
      subject: 'fiction',
      language: 'en',
      identifiers: ['eb2934ae-bb1a-4652-bce7-9f78fc5ca496'],
      uniqueIdentifierValue: 'eb2934ae-bb1a-4652-bce7-9f78fc5ca496',
      rights: ['Public Domain'],
      contributor: 'calibre (3.21.0) [http://calibre-ebook.com]',
      creator: 'Lewis Carroll',
      publisher: 'D. Appleton and Co',
      manifestItems: 45,
      spineItems: 14,
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/famouspaintings.epub',
      uniqueIdentifier: 'uuid_id',
      version: '2.0',
      title: 'Famous Paintings',
      date: '2012-12-15T00:00:00+00:00',
      subject: 'Fixed Layout Demonstration',
      language: 'en',
      identifiers: ['63912178-abce-4816-b882-930cb32d6207'],
      uniqueIdentifierValue: '63912178-abce-4816-b882-930cb32d6207',
      creator: 'Infogrid Pacific',
      contributor: 'calibre (3.21.0) [http://calibre-ebook.com]',
      manifestItems: 57,
      spineItems: 20,
      publisher: 'Infogrid Pacific',
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/linear-algebra.epub',
      uniqueIdentifier: 'uid',
      version: '3.0',
      title: 'A First Course in Linear Algebra',
      subject: 'education',
      language: 'en',
      identifiers: [
        'https://github.com/IDPF/edupub/tree/master/samples/linear-algebra',
      ],
      uniqueIdentifierValue: '63912178-abce-4816-b882-930cb32d6207',
      rights: [
        'This work is shared with the public using the GNU Free Documentation License, Version 1.2.',
        '© 2004 by Robert A. Beezer.'
      ],
      creator: 'Robert A. Beezer',
      manifestItems: 127,
      spineItems: 111,
      educationalRole: 'student',
      accessibilityFeatures: [
        'mathml',
        'readingOrder',
        'structuralNavigation',
        'tableOfContents',
        'unlocked'
      ],
      typicalAgeRange: '18+',
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/WCAG-ch1.epub',
      uniqueIdentifier: 'd21041e30',
      version: '3.0',
      title: 'World Cultures and Geography',
      subject: 'education',
      language: 'en-US',
      identifiers: ['41f1328c-0571-4e71-8be8-e65bc148281a'],
      uniqueIdentifierValue: '41f1328c-0571-4e71-8be8-e65bc148281a',
      creator: '',
      manifestItems: 41,
      spineItems: 2,
      accessibilityFeatures: [
        'alternativeText',
        'longDescription',
        'printPageNumbers',
        'readingOrder',
        'structuralNavigation',
        'tableOfContents',
        'unlocked',
      ],
      date: '2014-12-11T09:12:52+00:00',
      publisher: 'McDougal Littell',
      rights: [
        'Copyright © 2003 McDougal Littel, Inc.',
        'McDougal Littel, Inc. holds the copyright for these files and has provided permission to use them for the purpose of creating exemplar files. They should not be re-posted to other sites, nor may they be sold for commercial purposes.'
      ],
      educationalRole: 'student',
      typicalAgeRange: '18+',
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/structure-sample-01.epub',
      uniqueIdentifier: 'pub-id',
      version: '3.0',
      title: 'Education Structure Sample',
      subject: 'education',
      language: 'en',
      identifiers: ['test-sample-uc'],
      uniqueIdentifierValue: 'test-sample-uc',
      creator: 'Jane Doe',
      manifestItems: 45,
      spineItems: 23,
      accessibilityFeatures: [
        'alternativeText',
        'mathml',
        'index',
        'printPageNumbers',
        'readingOrder',
        'structuralNavigation',
        'tableOfContents',
      ],
      date: '2011-01-07',
      publisher: 'Pearson',
      educationalRole: 'student',
      typicalAgeRange: '18+',
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/Sway.epub',
      uniqueIdentifier: 'uuid_id',
      version: '2.0',
      title: 'Sway',
      subject: 'FIC000000',
      language: 'en',
      identifiers: ['9780316028363', 'a242af33-73b7-434b-8cde-511565f4f860'],
      uniqueIdentifierValue: '9780316028363',
      creator: 'Zachary Lazar',
      date: '2008-01-07T00:00:00+00:00',
      contributor: 'calibre (3.21.0) [http://calibre-ebook.com]',
      rights: ['WORLD ALL LANGUAGES'],
      publisher: 'Little, Brown and Company',
      description:
          "Three dramatic and emblematic stories intertwine in Zachary Lazar's extraordinary new novel, SWAY--the early days of the Rolling Stones, including the romantic triangle of Brian Jones, Anita Pallenberg, and Keith Richards; the life of avant-garde filmmaker Kenneth Anger; and the community of Charles Manson and his followers. Lazar illuminates an hour in American history when rapture found its roots in idolatrous figures and led to unprovoked and inexplicable violence. Connecting all the stories in this novel is Bobby Beausoleil, a beautiful California boy who appeared in an Anger film and eventually joined the Manson 'family.' With great artistry, Lazar weaves scenes from these real lives together into a true but heightened reality, making superstars human, giving demons reality, and restoring mythic events to the scale of daily life.",
      manifestItems: 12,
      spineItems: 8,
    ),
    _TestBookPackageInfo(
      file: 'test/resources/epub/sample1.epub',
      uniqueIdentifier: 'uuid_id',
      version: '2.0',
      title:
          "The Geography of Bliss: One Grump's Search for the Happiest Places in the World",
      subject: 'TRV000000',
      language: 'en',
      identifiers: ['9780446511070', '488e41dd-11d3-45e4-b776-173d26db6306'],
      uniqueIdentifierValue: '9780446511070',
      creator: 'Eric Weiner',
      manifestItems: 11,
      spineItems: 7,
      date: '2008-01-03T00:00:00+00:00',
      contributor: 'calibre (3.21.0) [http://calibre-ebook.com]',
      publisher: 'Twelve',
      description:
          "Part foreign affairs discourse, part humor, and part twisted self-help guide, The Geography of Bliss takes the reader from America to Iceland to India in search of happiness, or, in the crabby author's case, moments of 'un-unhappiness.' The book uses a beguiling mixture of travel, psychology, science and humor to investigate not what happiness is, but where it is. Are people in Switzerland happier because it is the most democratic country in the world? Do citizens of Singapore benefit psychologically by having their options limited by the government? Is the King of Bhutan a visionary for his initiative to calculate Gross National Happiness? Why is Asheville, North Carolina so damn happy? With engaging wit and surprising insights, Eric Weiner answers those questions and many others, offering travelers of all moods some interesting new ideas for sunnier destinations and dispositions.",
      rights: ['WORLD ALL LANGUAGES'],
    )
  ];

  for (final book in books) {
    test('EpubPackage parsing for ${book.title}', () async {
      final bytes = File(book.file).readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      final rootFilePath = await getEpubRootFilePath(archive);
      final rootFile = _getRootFile(archive, rootFilePath);

      final epubPackage = parsePackage(
        convert.utf8.decode(rootFile.content as List<int>),
      );

      expect(epubPackage.uniqueIdentifier, book.uniqueIdentifier);
      expect(epubPackage.version, book.version);

      // Metadata
      if (epubPackage.metadata is Epub2Metadata) {
        final metadata = epubPackage.metadata as Epub2Metadata;
        _checkCommonMetadataProperties(metadata, book);
      } else if (epubPackage.metadata is Epub3Metadata) {
        final metadata = epubPackage.metadata as Epub3Metadata;
        _checkCommonMetadataProperties(metadata, book);
        // expect(metadata.schemaOrg, book.schemaOrg);
        // expect(metadata.accessibilitySummary, book.accessibilitySummary);
        expect(metadata.accessibilityFeatures, book.accessibilityFeatures);
        expect(metadata.educationalRole, book.educationalRole);
        expect(metadata.typicalAgeRange, book.typicalAgeRange);
      } else {
        fail('Unknown metadata type');
      }

      // Manifest
      expect(epubPackage.manifest.items.length, book.manifestItems);

      // Spine
      expect(epubPackage.spine.items.length, book.spineItems);
    });
  }
}

void _checkCommonMetadataProperties(
  final Metadata metadata,
  final _TestBookPackageInfo testPackageInfo,
) {
  expect(metadata.title, testPackageInfo.title);
  expect(metadata.date, testPackageInfo.date);
  expect(metadata.subject, testPackageInfo.subject);
  expect(metadata.language, testPackageInfo.language);
  expect(metadata.identifiers, testPackageInfo.identifiers);
  expect(metadata.description, testPackageInfo.description);
  expect(metadata.rights, testPackageInfo.rights);
  expect(metadata.contributor, testPackageInfo.contributor);
  expect(metadata.creator, testPackageInfo.creator);
  expect(metadata.publisher, testPackageInfo.publisher);
}

ArchiveFile _getRootFile(final Archive archive, final String? rootFilePath) {
  if (rootFilePath == null) throw Exception('No root file found');
  final rootFile = archive.findFile(rootFilePath);
  return rootFile ?? (throw Exception('No root file found'));
}

class _TestBookPackageInfo {
  _TestBookPackageInfo({
    required this.file,
    required this.uniqueIdentifier,
    required this.version,
    required this.title,
    required this.subject,
    required this.language,
    required this.identifiers,
    required this.creator,
    required this.manifestItems,
    required this.spineItems,
    required this.uniqueIdentifierValue,
    this.accessibilityFeatures = const [],
    this.date = '',
    this.contributor = '',
    this.publisher = '',
    this.description = '',
    this.rights = const [],
    this.educationalRole = '',
    this.typicalAgeRange = '',
  });

  final String file;
  final String uniqueIdentifier;
  final String version;
  final String title;
  final String date;
  final String subject;
  final String language;
  final List<String> identifiers;
  final String uniqueIdentifierValue;
  final String description;
  final List<String> rights;
  final String contributor;
  final String creator;
  final String publisher;
  final int manifestItems;
  final int spineItems;
  // final String schemaOrg;
  // final String accessibilitySummary;
  final String educationalRole;
  final String typicalAgeRange;
  final List<String> accessibilityFeatures;
}
