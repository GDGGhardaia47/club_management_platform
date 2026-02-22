# Club Management Platform - Data Models Schema

## Overview
This document defines all data models and their schemas for the Club Management Platform.

---

## Table of Contents
1. [Member Model](#member-model)
2. [Department Model](#department-model)
3. [Task Model](#task-model)
4. [Event Model](#event-model)
5. [Event Template Model](#event-template-model)
6. [Activity Log Model](#activity-log-model)
7. [Notification Model](#notification-model)
8. [Supporting Models](#supporting-models)
9. [Enums](#enums)

---

## Member Model

### Firestore Schema

**Collection**: `members`  
**Document ID**: Auto-generated UID from Firebase Auth

```json
{
  "id": "string (UID)",
  "name": "string",
  "email": "string",
  "role": "string (enum: Member, Manager, CoreTeam, Admin)",
  "departmentId": "string (reference to departments collection)",
  "joinDate": "timestamp",
  "status": "string (enum: Active, Archived)",
  "profilePictureUrl": "string (Google Drive link)",
  "promotionHistory": [
    {
      "previousRole": "string",
      "newRole": "string",
      "changedBy": "string (member UID)",
      "changeDate": "timestamp",
      "reason": "string (optional)"
    }
  ],
  "departmentChangeHistory": [
    {
      "previousDepartment": "string (department ID)",
      "newDepartment": "string (department ID)",
      "changedBy": "string (member UID)",
      "changeDate": "timestamp",
      "reason": "string (optional)"
    }
  ],
  "archived": "boolean",
  "archivedDate": "timestamp (nullable)",
  "archivedBy": "string (member UID, nullable)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class Member {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String departmentId;
  final DateTime joinDate;
  final MemberStatus status;
  final String? profilePictureUrl;
  final List<PromotionHistory> promotionHistory;
  final List<DepartmentChangeHistory> departmentChangeHistory;
  final bool archived;
  final DateTime? archivedDate;
  final String? archivedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.departmentId,
    required this.joinDate,
    required this.status,
    this.profilePictureUrl,
    required this.promotionHistory,
    required this.departmentChangeHistory,
    required this.archived,
    this.archivedDate,
    this.archivedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Member.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Member(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: UserRole.fromString(data['role']),
      departmentId: data['departmentId'] ?? '',
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      status: MemberStatus.fromString(data['status']),
      profilePictureUrl: data['profilePictureUrl'],
      promotionHistory: (data['promotionHistory'] as List<dynamic>?)
              ?.map((e) => PromotionHistory.fromJson(e))
              .toList() ??
          [],
      departmentChangeHistory:
          (data['departmentChangeHistory'] as List<dynamic>?)
                  ?.map((e) => DepartmentChangeHistory.fromJson(e))
                  .toList() ??
              [],
      archived: data['archived'] ?? false,
      archivedDate: data['archivedDate'] != null
          ? (data['archivedDate'] as Timestamp).toDate()
          : null,
      archivedBy: data['archivedBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role.toString(),
      'departmentId': departmentId,
      'joinDate': Timestamp.fromDate(joinDate),
      'status': status.toString(),
      'profilePictureUrl': profilePictureUrl,
      'promotionHistory':
          promotionHistory.map((e) => e.toJson()).toList(),
      'departmentChangeHistory':
          departmentChangeHistory.map((e) => e.toJson()).toList(),
      'archived': archived,
      'archivedDate':
          archivedDate != null ? Timestamp.fromDate(archivedDate!) : null,
      'archivedBy': archivedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules

- **name**: Required, 2-50 characters
- **email**: Required, valid email format, unique
- **role**: Required, valid UserRole enum
- **departmentId**: Required
- **joinDate**: Required, auto-set on creation
- **status**: Required, default "Active"

---

## Department Model

### Firestore Schema

**Collection**: `departments`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "managerId": "string (reference to members collection)",
  "memberIds": ["string (array of member UIDs)"],
  "status": "string (enum: Active, Archived)",
  "archived": "boolean",
  "archivedDate": "timestamp (nullable)",
  "archivedBy": "string (member UID, nullable)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class Department {
  final String id;
  final String name;
  final String description;
  final String managerId;
  final List<String> memberIds;
  final DepartmentStatus status;
  final bool archived;
  final DateTime? archivedDate;
  final String? archivedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.managerId,
    required this.memberIds,
    required this.status,
    required this.archived,
    this.archivedDate,
    this.archivedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Department.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Department(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      managerId: data['managerId'] ?? '',
      memberIds: List<String>.from(data['memberIds'] ?? []),
      status: DepartmentStatus.fromString(data['status']),
      archived: data['archived'] ?? false,
      archivedDate: data['archivedDate'] != null
          ? (data['archivedDate'] as Timestamp).toDate()
          : null,
      archivedBy: data['archivedBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'managerId': managerId,
      'memberIds': memberIds,
      'status': status.toString(),
      'archived': archived,
      'archivedDate':
          archivedDate != null ? Timestamp.fromDate(archivedDate!) : null,
      'archivedBy': archivedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules

- **name**: Required, 3-50 characters, unique
- **description**: Optional, max 500 characters
- **managerId**: Required, must reference active member
- **memberIds**: Array, can be empty
- **status**: Required, default "Active"

---

## Task Model

### Firestore Schema

**Collection**: `tasks`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "assignedMembers": ["string (array of member UIDs)"],
  "assignedDepartment": "string (department ID, nullable)",
  "assignedRole": "string (role enum, nullable)",
  "deadline": "timestamp",
  "status": "string (enum: Pending, InProgress, Completed, Archived)",
  "relatedEventId": "string (event ID, nullable)",
  "googleDriveLinks": ["string (array of URLs)"],
  "createdBy": "string (member UID)",
  "createdByRole": "string (role at time of creation)",
  "archived": "boolean",
  "archivedDate": "timestamp (nullable)",
  "archivedBy": "string (member UID, nullable)",
  "completedDate": "timestamp (nullable)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "lastModifiedBy": "string (member UID)"
}
```

### Dart Model

```dart
class Task {
  final String id;
  final String title;
  final String description;
  final List<String> assignedMembers;
  final String? assignedDepartment;
  final UserRole? assignedRole;
  final DateTime deadline;
  final TaskStatus status;
  final String? relatedEventId;
  final List<String> googleDriveLinks;
  final String createdBy;
  final UserRole createdByRole;
  final bool archived;
  final DateTime? archivedDate;
  final String? archivedBy;
  final DateTime? completedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastModifiedBy;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedMembers,
    this.assignedDepartment,
    this.assignedRole,
    required this.deadline,
    required this.status,
    this.relatedEventId,
    required this.googleDriveLinks,
    required this.createdBy,
    required this.createdByRole,
    required this.archived,
    this.archivedDate,
    this.archivedBy,
    this.completedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.lastModifiedBy,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      assignedMembers: List<String>.from(data['assignedMembers'] ?? []),
      assignedDepartment: data['assignedDepartment'],
      assignedRole: data['assignedRole'] != null
          ? UserRole.fromString(data['assignedRole'])
          : null,
      deadline: (data['deadline'] as Timestamp).toDate(),
      status: TaskStatus.fromString(data['status']),
      relatedEventId: data['relatedEventId'],
      googleDriveLinks: List<String>.from(data['googleDriveLinks'] ?? []),
      createdBy: data['createdBy'] ?? '',
      createdByRole: UserRole.fromString(data['createdByRole']),
      archived: data['archived'] ?? false,
      archivedDate: data['archivedDate'] != null
          ? (data['archivedDate'] as Timestamp).toDate()
          : null,
      archivedBy: data['archivedBy'],
      completedDate: data['completedDate'] != null
          ? (data['completedDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastModifiedBy: data['lastModifiedBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'assignedMembers': assignedMembers,
      'assignedDepartment': assignedDepartment,
      'assignedRole': assignedRole?.toString(),
      'deadline': Timestamp.fromDate(deadline),
      'status': status.toString(),
      'relatedEventId': relatedEventId,
      'googleDriveLinks': googleDriveLinks,
      'createdBy': createdBy,
      'createdByRole': createdByRole.toString(),
      'archived': archived,
      'archivedDate':
          archivedDate != null ? Timestamp.fromDate(archivedDate!) : null,
      'archivedBy': archivedBy,
      'completedDate':
          completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastModifiedBy': lastModifiedBy,
    };
  }
  
  // Helper methods
  bool isOverdue() {
    return deadline.isBefore(DateTime.now()) && status != TaskStatus.completed;
  }
  
  bool canBeEditedBy(String memberId, UserRole role) {
    if (role == UserRole.admin || role == UserRole.coreTeam) return true;
    if (createdBy == memberId) return true;
    return false;
  }
}
```

### Validation Rules

- **title**: Required, 3-100 characters
- **description**: Optional, max 1000 characters
- **deadline**: Required, must be future date
- **At least one assignment**: assignedMembers OR assignedDepartment OR assignedRole
- **googleDriveLinks**: Valid URLs
- **status**: Required, default "Pending"

---

## Event Model

### Firestore Schema

**Collection**: `events`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "startDate": "timestamp",
  "endDate": "timestamp",
  "status": "string (enum: Planning, Ongoing, Completed, Archived)",
  "departmentIds": ["string (array of department IDs)"],
  "timeline": [
    {
      "id": "string",
      "title": "string",
      "description": "string",
      "targetDate": "timestamp",
      "status": "string (enum: Pending, Completed)",
      "responsibleDepartmentId": "string (nullable)",
      "responsibleMemberId": "string (nullable)"
    }
  ],
  "meetings": [
    {
      "id": "string",
      "title": "string",
      "dateTime": "timestamp",
      "duration": "number (minutes)",
      "location": "string",
      "attendeeIds": ["string (array of member UIDs)"],
      "departmentId": "string (nullable)",
      "notesUrl": "string (Google Drive link, nullable)",
      "status": "string (enum: Scheduled, Completed, Cancelled)"
    }
  ],
  "linkedTaskIds": ["string (array of task IDs)"],
  "googleDriveLinks": ["string (array of URLs)"],
  "createdBy": "string (member UID)",
  "createdByRole": "string (role at time of creation)",
  "archived": "boolean",
  "archivedDate": "timestamp (nullable)",
  "archivedBy": "string (member UID, nullable)",
  "templateId": "string (nullable)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final EventStatus status;
  final List<String> departmentIds;
  final List<Milestone> timeline;
  final List<Meeting> meetings;
  final List<String> linkedTaskIds;
  final List<String> googleDriveLinks;
  final String createdBy;
  final UserRole createdByRole;
  final bool archived;
  final DateTime? archivedDate;
  final String? archivedBy;
  final String? templateId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.departmentIds,
    required this.timeline,
    required this.meetings,
    required this.linkedTaskIds,
    required this.googleDriveLinks,
    required this.createdBy,
    required this.createdByRole,
    required this.archived,
    this.archivedDate,
    this.archivedBy,
    this.templateId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: EventStatus.fromString(data['status']),
      departmentIds: List<String>.from(data['departmentIds'] ?? []),
      timeline: (data['timeline'] as List<dynamic>?)
              ?.map((e) => Milestone.fromJson(e))
              .toList() ??
          [],
      meetings: (data['meetings'] as List<dynamic>?)
              ?.map((e) => Meeting.fromJson(e))
              .toList() ??
          [],
      linkedTaskIds: List<String>.from(data['linkedTaskIds'] ?? []),
      googleDriveLinks: List<String>.from(data['googleDriveLinks'] ?? []),
      createdBy: data['createdBy'] ?? '',
      createdByRole: UserRole.fromString(data['createdByRole']),
      archived: data['archived'] ?? false,
      archivedDate: data['archivedDate'] != null
          ? (data['archivedDate'] as Timestamp).toDate()
          : null,
      archivedBy: data['archivedBy'],
      templateId: data['templateId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.toString(),
      'departmentIds': departmentIds,
      'timeline': timeline.map((e) => e.toJson()).toList(),
      'meetings': meetings.map((e) => e.toJson()).toList(),
      'linkedTaskIds': linkedTaskIds,
      'googleDriveLinks': googleDriveLinks,
      'createdBy': createdBy,
      'createdByRole': createdByRole.toString(),
      'archived': archived,
      'archivedDate':
          archivedDate != null ? Timestamp.fromDate(archivedDate!) : null,
      'archivedBy': archivedBy,
      'templateId': templateId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  // Helper methods
  double getTimelineProgress() {
    if (timeline.isEmpty) return 0.0;
    int completed = timeline.where((m) => m.status == MilestoneStatus.completed).length;
    return completed / timeline.length;
  }
  
  int getLinkedTasksCompleted(List<Task> tasks) {
    return tasks.where((t) => t.status == TaskStatus.completed).length;
  }
}
```

### Validation Rules

- **title**: Required, 3-100 characters
- **description**: Optional, max 2000 characters
- **startDate**: Required
- **endDate**: Required, must be after startDate
- **departmentIds**: Required, at least one department
- **status**: Required, default "Planning"

---

## Event Template Model

### Firestore Schema

**Collection**: `event_templates`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "defaultDepartmentIds": ["string (array of department IDs)"],
  "defaultTaskTemplates": [
    {
      "title": "string",
      "description": "string",
      "assignedDepartmentId": "string (nullable)",
      "assignedRole": "string (nullable)",
      "deadlineOffset": "number (days relative to event start)",
      "googleDriveLinks": ["string"]
    }
  ],
  "defaultTimelineTemplates": [
    {
      "title": "string",
      "description": "string",
      "dateOffset": "number (days relative to event start)",
      "responsibleDepartmentId": "string (nullable)"
    }
  ],
  "defaultMeetingTemplates": [
    {
      "title": "string",
      "dateOffset": "number (days relative to event start)",
      "duration": "number (minutes)",
      "location": "string",
      "attendeeRoles": ["string (array of roles)"],
      "departmentId": "string (nullable)"
    }
  ],
  "status": "string (enum: Active, Archived)",
  "archived": "boolean",
  "archivedDate": "timestamp (nullable)",
  "createdBy": "string (member UID)",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Dart Model

```dart
class EventTemplate {
  final String id;
  final String name;
  final String description;
  final List<String> defaultDepartmentIds;
  final List<TaskTemplate> defaultTaskTemplates;
  final List<MilestoneTemplate> defaultTimelineTemplates;
  final List<MeetingTemplate> defaultMeetingTemplates;
  final TemplateStatus status;
  final bool archived;
  final DateTime? archivedDate;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultDepartmentIds,
    required this.defaultTaskTemplates,
    required this.defaultTimelineTemplates,
    required this.defaultMeetingTemplates,
    required this.status,
    required this.archived,
    this.archivedDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventTemplate.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventTemplate(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      defaultDepartmentIds:
          List<String>.from(data['defaultDepartmentIds'] ?? []),
      defaultTaskTemplates: (data['defaultTaskTemplates'] as List<dynamic>?)
              ?.map((e) => TaskTemplate.fromJson(e))
              .toList() ??
          [],
      defaultTimelineTemplates:
          (data['defaultTimelineTemplates'] as List<dynamic>?)
                  ?.map((e) => MilestoneTemplate.fromJson(e))
                  .toList() ??
              [],
      defaultMeetingTemplates:
          (data['defaultMeetingTemplates'] as List<dynamic>?)
                  ?.map((e) => MeetingTemplate.fromJson(e))
                  .toList() ??
              [],
      status: TemplateStatus.fromString(data['status']),
      archived: data['archived'] ?? false,
      archivedDate: data['archivedDate'] != null
          ? (data['archivedDate'] as Timestamp).toDate()
          : null,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'defaultDepartmentIds': defaultDepartmentIds,
      'defaultTaskTemplates':
          defaultTaskTemplates.map((e) => e.toJson()).toList(),
      'defaultTimelineTemplates':
          defaultTimelineTemplates.map((e) => e.toJson()).toList(),
      'defaultMeetingTemplates':
          defaultMeetingTemplates.map((e) => e.toJson()).toList(),
      'status': status.toString(),
      'archived': archived,
      'archivedDate':
          archivedDate != null ? Timestamp.fromDate(archivedDate!) : null,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
```

### Validation Rules

- **name**: Required, 3-50 characters
- **description**: Optional, max 500 characters
- **defaultDepartmentIds**: Optional
- **status**: Required, default "Active"

---

## Activity Log Model

### Firestore Schema

**Collection**: `activity_logs`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "actionType": "string (enum: see ActionType)",
  "actorId": "string (member UID)",
  "actorRole": "string (role at time of action)",
  "targetType": "string (enum: Member, Task, Event, Department, Template)",
  "targetId": "string",
  "beforeState": "object (JSON snapshot, nullable)",
  "afterState": "object (JSON snapshot, nullable)",
  "notes": "string (optional)",
  "ipAddress": "string (optional)",
  "timestamp": "timestamp"
}
```

### Dart Model

```dart
class ActivityLog {
  final String id;
  final ActionType actionType;
  final String actorId;
  final UserRole actorRole;
  final TargetType targetType;
  final String targetId;
  final Map<String, dynamic>? beforeState;
  final Map<String, dynamic>? afterState;
  final String? notes;
  final String? ipAddress;
  final DateTime timestamp;

  ActivityLog({
    required this.id,
    required this.actionType,
    required this.actorId,
    required this.actorRole,
    required this.targetType,
    required this.targetId,
    this.beforeState,
    this.afterState,
    this.notes,
    this.ipAddress,
    required this.timestamp,
  });

  factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLog(
      id: doc.id,
      actionType: ActionType.fromString(data['actionType']),
      actorId: data['actorId'] ?? '',
      actorRole: UserRole.fromString(data['actorRole']),
      targetType: TargetType.fromString(data['targetType']),
      targetId: data['targetId'] ?? '',
      beforeState: data['beforeState'] as Map<String, dynamic>?,
      afterState: data['afterState'] as Map<String, dynamic>?,
      notes: data['notes'],
      ipAddress: data['ipAddress'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'actionType': actionType.toString(),
      'actorId': actorId,
      'actorRole': actorRole.toString(),
      'targetType': targetType.toString(),
      'targetId': targetId,
      'beforeState': beforeState,
      'afterState': afterState,
      'notes': notes,
      'ipAddress': ipAddress,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
  
  String getDisplayMessage() {
    // Generate human-readable message based on action type
    // Example: "Jane Doe changed task status from 'Pending' to 'Completed'"
    return "${actorRole} performed ${actionType} on ${targetType}";
  }
}
```

### Validation Rules

- **actionType**: Required, valid enum
- **actorId**: Required
- **targetType**: Required
- **targetId**: Required
- **timestamp**: Auto-set on creation
- **Immutable**: Cannot be updated or deleted

---

## Notification Model

### Firestore Schema

**Collection**: `notifications`  
**Document ID**: Auto-generated

```json
{
  "id": "string",
  "userId": "string (member UID)",
  "type": "string (enum: TaskAssigned, TaskDeadline, TaskCompleted, etc.)",
  "title": "string",
  "message": "string",
  "relatedEntityType": "string (enum: Task, Event, Member, etc.)",
  "relatedEntityId": "string",
  "read": "boolean",
  "createdAt": "timestamp",
  "readAt": "timestamp (nullable)"
}
```

### Dart Model

```dart
class Notification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final TargetType relatedEntityType;
  final String relatedEntityId;
  final bool read;
  final DateTime createdAt;
  final DateTime? readAt;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.relatedEntityType,
    required this.relatedEntityId,
    required this.read,
    required this.createdAt,
    this.readAt,
  });

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Notification(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: NotificationType.fromString(data['type']),
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      relatedEntityType: TargetType.fromString(data['relatedEntityType']),
      relatedEntityId: data['relatedEntityId'] ?? '',
      read: data['read'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      readAt: data['readAt'] != null
          ? (data['readAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'type': type.toString(),
      'title': title,
      'message': message,
      'relatedEntityType': relatedEntityType.toString(),
      'relatedEntityId': relatedEntityId,
      'read': read,
      'createdAt': Timestamp.fromDate(createdAt),
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
    };
  }
}
```

---

## Supporting Models

### PromotionHistory

```dart
class PromotionHistory {
  final UserRole previousRole;
  final UserRole newRole;
  final String changedBy;
  final DateTime changeDate;
  final String? reason;

  PromotionHistory({
    required this.previousRole,
    required this.newRole,
    required this.changedBy,
    required this.changeDate,
    this.reason,
  });

  factory PromotionHistory.fromJson(Map<String, dynamic> json) {
    return PromotionHistory(
      previousRole: UserRole.fromString(json['previousRole']),
      newRole: UserRole.fromString(json['newRole']),
      changedBy: json['changedBy'] ?? '',
      changeDate: (json['changeDate'] as Timestamp).toDate(),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousRole': previousRole.toString(),
      'newRole': newRole.toString(),
      'changedBy': changedBy,
      'changeDate': Timestamp.fromDate(changeDate),
      'reason': reason,
    };
  }
}
```

### DepartmentChangeHistory

```dart
class DepartmentChangeHistory {
  final String previousDepartment;
  final String newDepartment;
  final String changedBy;
  final DateTime changeDate;
  final String? reason;

  DepartmentChangeHistory({
    required this.previousDepartment,
    required this.newDepartment,
    required this.changedBy,
    required this.changeDate,
    this.reason,
  });

  factory DepartmentChangeHistory.fromJson(Map<String, dynamic> json) {
    return DepartmentChangeHistory(
      previousDepartment: json['previousDepartment'] ?? '',
      newDepartment: json['newDepartment'] ?? '',
      changedBy: json['changedBy'] ?? '',
      changeDate: (json['changeDate'] as Timestamp).toDate(),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previousDepartment': previousDepartment,
      'newDepartment': newDepartment,
      'changedBy': changedBy,
      'changeDate': Timestamp.fromDate(changeDate),
      'reason': reason,
    };
  }
}
```

### Milestone

```dart
class Milestone {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final MilestoneStatus status;
  final String? responsibleDepartmentId;
  final String? responsibleMemberId;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.status,
    this.responsibleDepartmentId,
    this.responsibleMemberId,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetDate: (json['targetDate'] as Timestamp).toDate(),
      status: MilestoneStatus.fromString(json['status']),
      responsibleDepartmentId: json['responsibleDepartmentId'],
      responsibleMemberId: json['responsibleMemberId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetDate': Timestamp.fromDate(targetDate),
      'status': status.toString(),
      'responsibleDepartmentId': responsibleDepartmentId,
      'responsibleMemberId': responsibleMemberId,
    };
  }
}
```

### Meeting

```dart
class Meeting {
  final String id;
  final String title;
  final DateTime dateTime;
  final int duration; // in minutes
  final String location;
  final List<String> attendeeIds;
  final String? departmentId;
  final String? notesUrl;
  final MeetingStatus status;

  Meeting({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.duration,
    required this.location,
    required this.attendeeIds,
    this.departmentId,
    this.notesUrl,
    required this.status,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      duration: json['duration'] ?? 60,
      location: json['location'] ?? '',
      attendeeIds: List<String>.from(json['attendeeIds'] ?? []),
      departmentId: json['departmentId'],
      notesUrl: json['notesUrl'],
      status: MeetingStatus.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': Timestamp.fromDate(dateTime),
      'duration': duration,
      'location': location,
      'attendeeIds': attendeeIds,
      'departmentId': departmentId,
      'notesUrl': notesUrl,
      'status': status.toString(),
    };
  }
}
```

### TaskTemplate

```dart
class TaskTemplate {
  final String title;
  final String description;
  final String? assignedDepartmentId;
  final UserRole? assignedRole;
  final int deadlineOffset; // days relative to event start
  final List<String> googleDriveLinks;

  TaskTemplate({
    required this.title,
    required this.description,
    this.assignedDepartmentId,
    this.assignedRole,
    required this.deadlineOffset,
    required this.googleDriveLinks,
  });

  factory TaskTemplate.fromJson(Map<String, dynamic> json) {
    return TaskTemplate(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      assignedDepartmentId: json['assignedDepartmentId'],
      assignedRole: json['assignedRole'] != null
          ? UserRole.fromString(json['assignedRole'])
          : null,
      deadlineOffset: json['deadlineOffset'] ?? 7,
      googleDriveLinks: List<String>.from(json['googleDriveLinks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'assignedDepartmentId': assignedDepartmentId,
      'assignedRole': assignedRole?.toString(),
      'deadlineOffset': deadlineOffset,
      'googleDriveLinks': googleDriveLinks,
    };
  }
}
```

### MilestoneTemplate

```dart
class MilestoneTemplate {
  final String title;
  final String description;
  final int dateOffset; // days relative to event start
  final String? responsibleDepartmentId;

  MilestoneTemplate({
    required this.title,
    required this.description,
    required this.dateOffset,
    this.responsibleDepartmentId,
  });

  factory MilestoneTemplate.fromJson(Map<String, dynamic> json) {
    return MilestoneTemplate(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dateOffset: json['dateOffset'] ?? 0,
      responsibleDepartmentId: json['responsibleDepartmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dateOffset': dateOffset,
      'responsibleDepartmentId': responsibleDepartmentId,
    };
  }
}
```

### MeetingTemplate

```dart
class MeetingTemplate {
  final String title;
  final int dateOffset; // days relative to event start
  final int duration; // in minutes
  final String location;
  final List<UserRole> attendeeRoles;
  final String? departmentId;

  MeetingTemplate({
    required this.title,
    required this.dateOffset,
    required this.duration,
    required this.location,
    required this.attendeeRoles,
    this.departmentId,
  });

  factory MeetingTemplate.fromJson(Map<String, dynamic> json) {
    return MeetingTemplate(
      title: json['title'] ?? '',
      dateOffset: json['dateOffset'] ?? 0,
      duration: json['duration'] ?? 60,
      location: json['location'] ?? '',
      attendeeRoles: (json['attendeeRoles'] as List<dynamic>?)
              ?.map((e) => UserRole.fromString(e))
              .toList() ??
          [],
      departmentId: json['departmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateOffset': dateOffset,
      'duration': duration,
      'location': location,
      'attendeeRoles': attendeeRoles.map((e) => e.toString()).toList(),
      'departmentId': departmentId,
    };
  }
}
```

---

## Enums

### UserRole

```dart
enum UserRole {
  member,
  manager,
  coreTeam,
  admin;

  @override
  String toString() {
    switch (this) {
      case UserRole.member:
        return 'Member';
      case UserRole.manager:
        return 'Manager';
      case UserRole.coreTeam:
        return 'CoreTeam';
      case UserRole.admin:
        return 'Admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value) {
      case 'Member':
        return UserRole.member;
      case 'Manager':
        return UserRole.manager;
      case 'CoreTeam':
        return UserRole.coreTeam;
      case 'Admin':
        return UserRole.admin;
      default:
        return UserRole.member;
    }
  }
}
```

### TaskStatus

```dart
enum TaskStatus {
  pending,
  inProgress,
  completed,
  archived;

  @override
  String toString() {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'InProgress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.archived:
        return 'Archived';
    }
  }

  static TaskStatus fromString(String value) {
    switch (value) {
      case 'Pending':
        return TaskStatus.pending;
      case 'InProgress':
        return TaskStatus.inProgress;
      case 'Completed':
        return TaskStatus.completed;
      case 'Archived':
        return TaskStatus.archived;
      default:
        return TaskStatus.pending;
    }
  }
}
```

### EventStatus

```dart
enum EventStatus {
  planning,
  ongoing,
  completed,
  archived;

  @override
  String toString() {
    switch (this) {
      case EventStatus.planning:
        return 'Planning';
      case EventStatus.ongoing:
        return 'Ongoing';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.archived:
        return 'Archived';
    }
  }

  static EventStatus fromString(String value) {
    switch (value) {
      case 'Planning':
        return EventStatus.planning;
      case 'Ongoing':
        return EventStatus.ongoing;
      case 'Completed':
        return EventStatus.completed;
      case 'Archived':
        return EventStatus.archived;
      default:
        return EventStatus.planning;
    }
  }
}
```

### MemberStatus

```dart
enum MemberStatus {
  active,
  archived;

  @override
  String toString() {
    switch (this) {
      case MemberStatus.active:
        return 'Active';
      case MemberStatus.archived:
        return 'Archived';
    }
  }

  static MemberStatus fromString(String value) {
    switch (value) {
      case 'Active':
        return MemberStatus.active;
      case 'Archived':
        return MemberStatus.archived;
      default:
        return MemberStatus.active;
    }
  }
}
```

### Additional Enums

```dart
enum DepartmentStatus { active, archived }
enum TemplateStatus { active, archived }
enum MilestoneStatus { pending, completed }
enum MeetingStatus { scheduled, completed, cancelled }

enum ActionType {
  memberCreated,
  memberUpdated,
  memberRoleChanged,
  memberDepartmentChanged,
  memberArchived,
  memberRestored,
  memberDeleted,
  taskCreated,
  taskUpdated,
  taskAssigned,
  taskStatusChanged,
  taskArchived,
  taskRestored,
  taskDeleted,
  eventCreated,
  eventUpdated,
  eventArchived,
  eventRestored,
  eventDeleted,
  meetingScheduled,
  meetingUpdated,
  meetingCancelled,
  departmentCreated,
  departmentUpdated,
  departmentManagerChanged,
  departmentArchived,
  departmentRestored,
  templateCreated,
  templateUpdated,
  templateArchived,
  templateInstantiated,
}

enum TargetType {
  member,
  task,
  event,
  department,
  template,
}

enum NotificationType {
  taskAssigned,
  taskDeadline,
  taskOverdue,
  taskCompleted,
  eventCreated,
  meetingScheduled,
  meetingReminder,
  roleChanged,
  departmentChanged,
}
```

---

## Summary

This document provides complete data model schemas for:
- **7 main collections** (members, departments, tasks, events, event_templates, activity_logs, notifications)
- **13 supporting models** for nested data structures
- **11 enums** for type safety
- **Firestore JSON schema** for each collection
- **Dart model implementations** with serialization
- **Validation rules** for all models
- **Helper methods** for common operations

All models include proper type safety, null safety, and conversion methods for Firebase integration.
