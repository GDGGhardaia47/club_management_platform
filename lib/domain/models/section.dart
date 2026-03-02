/// Section entity — pure Dart, no Firebase or Flutter imports.
class Section {
  final String id;
  final String name;
  final String departmentId;
  final bool archived;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Section({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.archived,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      archived: json['archived'] as bool? ?? false,
      archivedAt: json['archivedAt'] != null
          ? DateTime.parse(json['archivedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departmentId': departmentId,
      'archived': archived,
      'archivedAt': archivedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
