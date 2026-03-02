/// Event model representing a GDG Ghardaia event.
/// Status can be: Planning, Ongoing, or Done.
class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String description;
  final String status; // 'Planning', 'Ongoing', 'Done'
  final List<String> departmentsInvolved;
  final List<String> sectionsInvolved;
  final List<String> assignedMemberIds;
  final bool isArchived;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.status,
    required this.departmentsInvolved,
    required this.sectionsInvolved,
    required this.assignedMemberIds,
    this.isArchived = false,
  });

  /// Factory to create an Event from JSON (for API / mock data).
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled Event',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      location: json['location'] ?? 'GDG Ghardaia',
      description: json['description'] ?? '',
      status: json['status'] ?? 'Planning',
      departmentsInvolved: List<String>.from(json['departmentsInvolved'] ?? []),
      sectionsInvolved: List<String>.from(json['sectionsInvolved'] ?? []),
      assignedMemberIds: List<String>.from(json['assignedMemberIds'] ?? []),
      isArchived: json['isArchived'] ?? false,
    );
  }
}
