import 'package:xml/xml.dart';

/// Represents the navigation structure of an EPUB document.
///
/// This class provides access to the title of the document and
/// a list of navigation points.
class EpubNavigation {
  /// Creates a new [EpubNavigation] with the given [document].
  EpubNavigation({required this.document});

  /// The XML document that represents the EPUB document.
  final XmlDocument document;

  /// Gets the title of the EPUB document.
  String get title {
    final titleElement =
        document.findAllElements('docTitle').first.findElements('text').first;
    return titleElement.value ?? '';
  }

  /// Gets a list of navigation points in the EPUB document.
  List<NavPoint> get navPoints {
    return document.findAllElements('navPoint').map((final navPointElement) {
      final classAttribute = navPointElement.getAttribute('class');
      final id = navPointElement.getAttribute('id');
      final playOrder = navPointElement.getAttribute('playOrder');
      final label = navPointElement
              .findElements('navLabel')
              .first
              .findElements('text')
              .first
              .value ??
          '';
      final content =
          navPointElement.findElements('content').first.getAttribute('src');
      return NavPoint(
        classAttribute: classAttribute!,
        id: id!,
        playOrder: playOrder!,
        label: label,
        content: content!,
      );
    }).toList();
  }
}

/// Represents a navigation point in an EPUB document.
///
/// Each navigation point has a class attribute, an ID, a play order,
/// a label, and a content.
class NavPoint {
  /// Creates a new [NavPoint] with the given attributes.
  NavPoint({
    required this.classAttribute,
    required this.id,
    required this.playOrder,
    required this.label,
    required this.content,
  });

  /// The class attribute of the navigation point.
  final String classAttribute;

  /// The ID of the navigation point.
  final String id;

  /// The play order of the navigation point.
  final String playOrder;

  /// The label of the navigation point.
  final String label;

  /// The content source of the navigation point.
  final String content;

  @override
  String toString() {
    return 'NavPoint(classAttribute: $classAttribute, id: $id, playOrder: $playOrder, label: $label, content: $content)';
  }
}
