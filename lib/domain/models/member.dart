/// Member entity — pure Dart, no Firebase or Flutter imports.
enum MemberRole { member, coreTeam }

enum MemberStatus { active, archived }

class Member {
  final String id;
  final String name;
  final String email;
  final MemberRole role;
  final String departmentId;
  final String? sectionId;
  final DateTime joinDate;
  final MemberStatus status;
  final bool archived;
  final DateTime? archivedAt;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Member({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.departmentId,
    this.sectionId,
    required this.joinDate,
    required this.status,
    required this.archived,
    this.archivedAt,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Permission helpers (derived from role) ──
  bool get canManageMembers => role == MemberRole.coreTeam;
  bool get canManageEvents  => role == MemberRole.coreTeam;
  bool get canArchive       => role == MemberRole.coreTeam;

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] == 'core_team' ? MemberRole.coreTeam : MemberRole.member,
      departmentId: json['departmentId'] as String? ?? '',
      sectionId: json['sectionId'] as String?,
      joinDate: DateTime.parse(json['joinDate'] as String),
      status: json['status'] == 'archived' ? MemberStatus.archived : MemberStatus.active,
      archived: json['archived'] as bool? ?? false,
      archivedAt: json['archivedAt'] != null
          ? DateTime.parse(json['archivedAt'] as String)
          : null,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == MemberRole.coreTeam ? 'core_team' : 'member',
      'departmentId': departmentId,
      'sectionId': sectionId,
      'joinDate': joinDate.toIso8601String(),
      'status': status == MemberStatus.archived ? 'archived' : 'active',
      'archived': archived,
      'archivedAt': archivedAt?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Member copyWith({
    String? id,
    String? name,
    String? email,
    MemberRole? role,
    String? departmentId,
    String? sectionId,
    DateTime? joinDate,
    MemberStatus? status,
    bool? archived,
    DateTime? archivedAt,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      departmentId: departmentId ?? this.departmentId,
      sectionId: sectionId ?? this.sectionId,
      joinDate: joinDate ?? this.joinDate,
      status: status ?? this.status,
      archived: archived ?? this.archived,
      archivedAt: archivedAt ?? this.archivedAt,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
