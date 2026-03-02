/// Member model representing a GDG Ghardaia club member.
/// Each member belongs to a Department → Section hierarchy.
class Member {
  final String id;
  final String name;
  final String section;
  final String department;
  final String roleTitle;
  final DateTime joinDate;
  final bool isCoreTeam;
  final bool isArchived;

  const Member({
    required this.id,
    required this.name,
    required this.section,
    required this.department,
    required this.roleTitle,
    required this.joinDate,
    this.isCoreTeam = false,
    this.isArchived = false,
  });
}
