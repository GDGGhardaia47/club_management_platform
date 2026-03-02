/// Department entity — pure Dart, no Firebase or Flutter imports.
class Department {
  final String id;
  final String name;
  final String? description;
  final bool archived;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Department({
    required this.id,
    required this.name,
    this.description,
    required this.archived,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
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
      'description': description,
      'archived': archived,
      'archivedAt': archivedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
