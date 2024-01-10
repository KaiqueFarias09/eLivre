import 'package:liber_epub/features/epub/entities/navigation/nav_point.dart';
import 'package:xml/xml.dart';

/// Represents the navigation structure of an EPUB document.
///
/// This class provides access to the title of the document and
/// a list of navigation points.
class Navigation {
  /// Creates a new [Navigation] with the given [document].
  Navigation({required this.document});

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
      final subNavPoints = navPointElement
          .findElements('navPoint')
          .map((final subNavPointElement) {
        return NavPoint(
          classAttribute: subNavPointElement.getAttribute('class') ?? '',
          id: subNavPointElement.getAttribute('id') ?? '',
          playOrder: subNavPointElement.getAttribute('playOrder') ?? '',
          label: subNavPointElement
                  .findElements('navLabel')
                  .first
                  .findElements('text')
                  .first
                  .value ??
              '',
          content: subNavPointElement
                  .findElements('content')
                  .first
                  .getAttribute('src') ??
              '',
        );
      }).toList();

      return NavPoint(
        classAttribute: classAttribute ?? '',
        id: id ?? '',
        playOrder: playOrder ?? '',
        label: label,
        content: content ?? '',
        subNavPoints: subNavPoints,
      );
    }).toList();
  }
}
