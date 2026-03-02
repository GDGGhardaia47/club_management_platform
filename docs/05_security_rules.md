# Club Management Platform — Security Rules

**Current Target Version:** `v0.1 (MVP)`

Security rules are simplified for v0.1. Two roles, three permission flags. No complex RBAC until future versions.

---

## Permission Model

### Roles (v0.1)

| Role | Value | Description |
|------|-------|-------------|
| Member | `'member'` | Regular club member — read-only access |
| Core Team | `'core_team'` | Can manage members, events, and archive |

### Permission Flags (v0.1)

| Flag | Granted To | Controls |
|------|-----------|---------|
| `canManageMembers` | `core_team` | Create, edit, archive members |
| `canManageEvents` | `core_team` | Create, edit, archive events |
| `canArchive` | `core_team` | Archive and restore members/events |

No department-level permissions. No manager role. No admin role. These come in future versions.

---

## Access Control Summary

| Action | Member | Core Team |
|--------|--------|-----------|
| View member list | ✅ | ✅ |
| View member detail | ✅ | ✅ |
| Create member | ❌ | ✅ |
| Edit member | ❌ | ✅ |
| Archive member | ❌ | ✅ |
| View event list | ✅ | ✅ |
| View event detail | ✅ | ✅ |
| Create event | ❌ | ✅ |
| Edit event | ❌ | ✅ |
| Archive event | ❌ | ✅ |
| View departments | ✅ | ✅ |
| Manage departments | ❌ | ✅ |
| View archive | ✅ (read-only) | ✅ |
| Restore from archive | ❌ | ✅ |

---

## Firestore Security Rules (v0.1)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ─────────────────────────────────────────────
    // HELPER FUNCTIONS
    // ─────────────────────────────────────────────

    function isAuthenticated() {
      return request.auth != null;
    }

    function currentUser() {
      return get(/databases/$(database)/documents/members/$(request.auth.uid)).data;
    }

    function isCoreTeam() {
      return isAuthenticated() && currentUser().role == 'core_team';
    }

    function isActiveMember() {
      return isAuthenticated() && currentUser().archived == false;
    }

    // ─────────────────────────────────────────────
    // MEMBERS COLLECTION
    // ─────────────────────────────────────────────

    match /members/{memberId} {
      // Any authenticated active user can read member profiles
      allow read: if isActiveMember();

      // Only Core Team can create members
      allow create: if isCoreTeam()
        && request.resource.data.keys().hasAll(['name', 'email', 'role', 'departmentId'])
        && request.resource.data.role in ['member', 'core_team'];

      // Only Core Team can update members
      allow update: if isCoreTeam()
        && request.resource.data.role in ['member', 'core_team'];

      // Deletes are never allowed — use archive (soft delete) instead
      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // DEPARTMENTS COLLECTION
    // ─────────────────────────────────────────────

    match /departments/{departmentId} {
      // Any authenticated active user can read departments
      allow read: if isActiveMember();

      // Only Core Team can create/update departments
      allow create, update: if isCoreTeam()
        && request.resource.data.keys().hasAny(['name'])
        && request.resource.data.name is string;

      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // SECTIONS COLLECTION
    // ─────────────────────────────────────────────

    match /sections/{sectionId} {
      allow read: if isActiveMember();

      allow create, update: if isCoreTeam()
        && request.resource.data.keys().hasAll(['name', 'departmentId']);

      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // EVENTS COLLECTION
    // ─────────────────────────────────────────────

    match /events/{eventId} {
      // Any authenticated active user can read events
      allow read: if isActiveMember();

      // Only Core Team can create events
      allow create: if isCoreTeam()
        && request.resource.data.keys().hasAll(['title', 'startDate', 'endDate'])
        && request.resource.data.title is string;

      // Only Core Team can update events (including archiving)
      allow update: if isCoreTeam();

      allow delete: if false;
    }

  }
}
```

---

## Notes

### Why No Deletes?
All deletions in v0.1 are soft deletes (set `archived: true`). Hard deletes from Firestore are reserved for a future Admin role (v1.0+).

### Self-Profile Edits
v0.1 does **not** support members editing their own profiles. Only Core Team can edit members. Self-edit capability is planned for a future minor release.

### Security at the UI Level
In addition to Firestore rules, the Flutter UI hides management actions from regular members. Security rules are the authoritative enforcement layer; UI is a convenience layer.

### Future Security Additions

| Feature | Version |
|---------|---------|
| Department-scoped writes | 0.2+ |
| Manager role permissions | 0.3+ |
| Admin role (hard deletes) | 1.0 |
| Self-profile edits | 0.4+ |
| Read-scoped by department | 0.5+ |

---

## Testing Security Rules

### Test Cases for v0.1

#### Member (regular user)
- ✅ Can read any member document
- ✅ Can read any event document
- ✅ Can read any department / section
- ❌ Cannot create a member document
- ❌ Cannot update a member document
- ❌ Cannot create an event
- ❌ Cannot update an event

#### Core Team
- ✅ Can read everything
- ✅ Can create members
- ✅ Can update members (including `archived: true`)
- ✅ Can create events
- ✅ Can update events (including `archived: true`)
- ✅ Can create/update departments and sections
- ❌ Cannot delete any document (hard delete blocked)

#### Unauthenticated
- ❌ Cannot read or write anything

### Manual Test Pattern

```javascript
// Firebase Firestore emulator test (pseudocode)

// Setup: create a 'member' role user and a 'core_team' role user

// member user tries to write — should fail
await assertFails(memberDb.collection('members').add({ name: 'Test' }));

// core_team user writes — should succeed
await assertSucceeds(coreTeamDb.collection('members').add({
  name: 'New Member',
  email: 'new@example.com',
  role: 'member',
  departmentId: 'dept_001',
  archived: false,
  joinDate: new Date(),
  createdAt: new Date(),
  updatedAt: new Date(),
}));
```
