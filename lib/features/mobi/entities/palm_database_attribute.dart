class PalmDatabaseAttribute {
  PalmDatabaseAttribute({
    required this.name,
    required final int field,
    required this.val,
  }) {
    val = val & field;
  }
  String name;
  int val;

  @override
  String toString() {
    return '$name: ${val != 0}';
  }
}
