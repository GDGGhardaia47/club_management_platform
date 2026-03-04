# Club Management Platform — Data Models

**Current Target Version:** `v0.1 (MVP)`

Only models required for v0.1 are defined here. Future models are listed at the end — do not implement them until their respective version.

---

## Table of Contents
1. [Member](#member)
2. [Department](#department)
3. [Section](#section)
4. [Event](#event)
5. [Future Models (Not in v0.1)](#future-models-not-in-v01)

---

## Member

**Firestore Collection:** `members`
**Document ID:** Firebase Auth UID

### Schema

```json
{
  "id": "string (Firebase Auth UID)",
  "name": "string",
  "email": "string",
  "role": "string (enum v0.1: 'member' | 'core_team' — full hierarchy added incrementally from v0.2)",
  "departmentId": "string (reference to departments)",
  "sectionId": "string | null (reference to sections)",
  "joinDate": "timestamp",
  "status": "string (enum: 'active' | 'archived')",
  "archived": "boolean",
  "archivedAt": "timestamp | null",
  "profilePictureUrl": "string | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Permission Flags (derived, not stored)

Computed from role at runtime in v0.1. From v0.4 onward, permissions are driven by the Discord-style role system (assigned by Admin).

| Flag | `member` | `core_team` |
|------|----------|-------------|
| `canManageMembers` | false | true |
| `canManageEvents` | false | true |
| `canArchive` | false | true |

> **Future (v0.4+):** Permission flags will be resolved from a `Role` document rather than hardcoded per role name. Admins will create roles and assign permission sets via the Discord-style role management UI.

### Dart Model

```dart
// v0.1 roles only. Full hierarchy: member → sectionMember → departmentManager → coreTeam → admin
// From v0.2 onward, new roles are introduced incrementally.
// From v0.4, roles become dynamic (Discord-style) managed by Admin.
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

  Member({
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

  // Permission helpers
  bool get canManageMembers => role == MemberRole.coreTeam;
  bool get canManageEvents => role == MemberRole.coreTeam;
  bool get canArchive => role == MemberRole.coreTeam;

  factory Member.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Member(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] == 'core_team' ? MemberRole.coreTeam : MemberRole.member,
      departmentId: data['departmentId'] ?? '',
      sectionId: data['sectionId'],
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      status: data['status'] == 'archived' ? MemberStatus.archived : MemberStatus.active,
      archived: data['archived'] ?? false,
      archivedAt: data['archivedAt'] != null
          ? (data['archivedAt'] as Timestamp).toDate()
          : null,
      profilePictureUrl: data['profilePictureUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role == MemberRole.coreTeam ? 'core_team' : 'member',
      'departmentId': departmentId,
      'sectionId': sectionId,
      'joinDate': Timestamp.fromDate(joinDate),
      'status': status == MemberStatus.archived ? 'archived' : 'active',
      'archived': archived,
      'archivedAt': archivedAt != null ? Timestamp.fromDate(archivedAt!) : null,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules
- `name`: required, 2–50 characters
- `email`: required, valid email format
- `role`: required, must be `'member'` or `'core_team'` in v0.1 — additional roles (`section_member`, `department_manager`, `admin`) added in v0.2–v0.4
- `departmentId`: required
- `joinDate`: auto-set on creation

---

## Department

**Firestore Collection:** `departments`
**Document ID:** Auto-generated

### Schema

```json
{
  "id": "string",
  "name": "string",
  "description": "string | null",
  "archived": "boolean",
  "archivedAt": "timestamp | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class Department {
  final String id;
  final String name;
  final String? description;
  final bool archived;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Department({
    required this.id,
    required this.name,
    this.description,
    required this.archived,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Department(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      archived: data['archived'] ?? false,
      archivedAt: data['archivedAt'] != null
          ? (data['archivedAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'archived': archived,
      'archivedAt': archivedAt != null ? Timestamp.fromDate(archivedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules
- `name`: required, 2–50 characters

---

## Section

**Firestore Collection:** `sections`
**Document ID:** Auto-generated

### Schema

```json
{
  "id": "string",
  "name": "string",
  "departmentId": "string (reference to departments)",
  "archived": "boolean",
  "archivedAt": "timestamp | null",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class Section {
  final String id;
  final String name;
  final String departmentId;
  final bool archived;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Section({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.archived,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Section.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Section(
      id: doc.id,
      name: data['name'] ?? '',
      departmentId: data['departmentId'] ?? '',
      archived: data['archived'] ?? false,
      archivedAt: data['archivedAt'] != null
          ? (data['archivedAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'departmentId': departmentId,
      'archived': archived,
      'archivedAt': archivedAt != null ? Timestamp.fromDate(archivedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules
- `name`: required, 2–50 characters
- `departmentId`: required, must reference an existing department

---

## Event

**Firestore Collection:** `events`
**Document ID:** Auto-generated

### Schema

```json
{
  "id": "string",
  "title": "string",
  "description": "string | null",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "status": "string (enum: 'upcoming' | 'ongoing' | 'completed' | 'archived')",
  "archived": "boolean",
  "archivedAt": "timestamp | null",
  "createdBy": "string (member ID)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
enum EventStatus { upcoming, ongoing, completed, archived }

class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final EventStatus status;
  final bool archived;
  final DateTime? archivedAt;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.archived,
    this.archivedAt,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: _statusFromString(data['status']),
      archived: data['archived'] ?? false,
      archivedAt: data['archivedAt'] != null
          ? (data['archivedAt'] as Timestamp).toDate()
          : null,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static EventStatus _statusFromString(String? value) {
    switch (value) {
      case 'ongoing':    return EventStatus.ongoing;
      case 'completed':  return EventStatus.completed;
      case 'archived':   return EventStatus.archived;
      default:           return EventStatus.upcoming;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.name,
      'archived': archived,
      'archivedAt': archivedAt != null ? Timestamp.fromDate(archivedAt!) : null,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules
- `title`: required, 3–100 characters
- `startDate`: required
- `endDate`: required, must be >= `startDate`
- `createdBy`: required, auto-set from current user

---

## Future Models (Not in v0.1)

The following models are **not implemented** in v0.1. They are listed here for awareness. Do not create these collections in Firestore until their respective version ships.

| Model | Planned Version | Description |
|-------|----------------|-------------|
| `Task` | 0.5+ | Task assignment engine |
| `Role` | 0.4+ | Discord-style role with named permission sets (Admin-managed) |
| `ActivityLog` | 0.3+ | Audit trail for all actions |
| `EventTemplate` | 0.7+ | Reusable event templates |
| `Notification` | 0.7+ | In-app notification records |
| `Analytics` | 0.9+ | Aggregated metrics |

### Future: Task (sketch only)

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "assignedMemberIds": ["string"],
  "assignedDepartmentId": "string | null",
  "deadline": "timestamp",
  "status": "string (pending | in_progress | completed | archived)",
  "relatedEventId": "string | null",
  "driveLinks": ["string"],
  "createdBy": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Future: ActivityLog (sketch only)

```json
{
  "id": "string",
  "actionType": "string",
  "actorId": "string",
  "targetType": "string (member | event | department | section)",
  "targetId": "string",
  "before": "map | null",
  "after": "map | null",
  "timestamp": "timestamp"
}
```
