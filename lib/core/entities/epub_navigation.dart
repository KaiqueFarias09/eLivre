import 'package:xml/xml.dart';

class EpubNavigation {
  EpubNavigation({required this.document});
  final XmlDocument document;

  String get title {
    final titleElement =
        document.findAllElements('docTitle').first.findElements('text').first;
    return titleElement.value ?? '';
  }

  List<NavPoint> get navPoints {
    return document.findAllElements('navPoint').map((navPointElement) {
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

class NavPoint {
  NavPoint({
    required this.classAttribute,
    required this.id,
    required this.playOrder,
    required this.label,
    required this.content,
  });
  final String classAttribute;
  final String id;
  final String playOrder;
  final String label;
  final String content;

  @override
  String toString() {
    return 'NavPoint(classAttribute: $classAttribute, id: $id, playOrder: $playOrder, label: $label, content: $content)';
  }
}
