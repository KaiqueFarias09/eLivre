/// Represents a navigation point in an EPUB document.
///
/// Each navigation point has a class attribute, an ID, a play order,
/// a label, a content, and possibly sub-navigation points.
class NavPoint {
  /// Creates a new [NavPoint] with the given attributes.
  NavPoint({
    required this.classAttribute,
    required this.id,
    required this.playOrder,
    required this.label,
    required this.content,
    this.subNavPoints = const [],
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

  /// Sub-navigation points.
  final List<NavPoint> subNavPoints;

  @override
  String toString() {
    return 'NavPoint(classAttribute: $classAttribute, id: $id, playOrder: $playOrder, label: $label, content: $content, subNavPoints: $subNavPoints)';
  }
}
