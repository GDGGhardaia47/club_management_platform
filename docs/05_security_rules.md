# Club Management Platform — Security Rules

**Current Target Version:** `v0.1 (MVP)`

Security rules are simplified for v0.1. Two roles, three permission flags. No complex RBAC until future versions.

> **Planned role hierarchy:** `Member → Section Member → Department Manager → Core Team → Admin`
> Roles are introduced incrementally (v0.2–v0.4). From v0.4, role permissions are managed via a Discord-style system where Admins create roles and assign permission sets.

---

## Permission Model

> **Permanent rule (all versions):** There is no self-registration. Member accounts are created exclusively by Core Team (v0.1–v0.3) or by Admin / Core Team with the appropriate permission (v0.4+). A user who authenticates with Google but has no existing member document in Firestore is denied access. This is enforced at both the UI level and the Firestore rules level.

### Roles (v0.1)

| Role | Value | Description |
|------|-------|-------------|
| Member | `'member'` | Regular club member — read-only access |
| Core Team | `'core_team'` | Has configurable permissions |
| Admin | `'admin'` | Full system access |

### Permission Flags (v0.1)

| Flag | Granted To | Controls |
|------|-----------|---------|
| `canManageMembers` | `core_team` (optional), `admin` | Create, edit, archive members |
| `canManageEvents` | `core_team` (optional), `admin` | Create, edit, archive events |
| `canArchive` | `core_team` (optional), `admin` | Archive and restore members/events |

No department-level permissions. No Section Member role. No Department Manager role. These come in future versions.

> From v0.4 onward, Firestore rules will validate against a `roles` collection rather than a hardcoded role string.

---

## Access Control Summary

| Action | Member | Core Team | Admin |
|--------|--------|-----------|-------|
| View member list | ✅ | ✅ | ✅ |
| View member detail | ✅ | ✅ | ✅ |
| Create member | ❌ | ✅ (if `canManageMembers`) | ✅ |
| Edit member | ❌ | ✅ (if `canManageMembers`) | ✅ |
| Archive member | ❌ | ✅ (if `canManageMembers`) | ✅ |
| View event list | ✅ | ✅ | ✅ |
| View event detail | ✅ | ✅ | ✅ |
| Create event | ❌ | ✅ (if `canManageEvents`) | ✅ |
| Edit event | ❌ | ✅ (if `canManageEvents`) | ✅ |
| Archive event | ❌ | ✅ (if `canManageEvents`) | ✅ |
| View departments | ✅ | ✅ | ✅ |
| Manage departments | ❌ | ✅ | ✅ |
| View archive | ❌ | ✅ (if `canArchive`) | ✅ |
| Restore from archive | ❌ | ✅ (if `canArchive`) | ✅ |

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

    function isAdmin() {
      return isAuthenticated() && currentUser().role == 'admin';
    }

    function canManageMembers() {
      return isAdmin() || (isAuthenticated() && currentUser().role == 'core_team' && currentUser().canManageMembers == true);
    }
    
    function canManageEvents() {
      return isAdmin() || (isAuthenticated() && currentUser().role == 'core_team' && currentUser().canManageEvents == true);
    }

    function canArchive() {
      return isAdmin() || (isAuthenticated() && currentUser().role == 'core_team' && currentUser().canArchive == true);
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

      // Only Admin or Core Team with access can create members
      allow create: if canManageMembers()
        && request.resource.data.keys().hasAll(['name', 'email', 'role', 'departmentId'])
        && request.resource.data.role in ['member', 'core_team', 'admin'];

      // Only Admin or Core Team with access can update members
      allow update: if canManageMembers()
        && request.resource.data.role in ['member', 'core_team', 'admin'];

      // Deletes are never allowed — use archive (soft delete) instead
      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // DEPARTMENTS COLLECTION
    // ─────────────────────────────────────────────

    match /departments/{departmentId} {
      // Any authenticated active user can read departments
      allow read: if isActiveMember();

      // Only Admin/CoreTeam can create/update departments
      allow create, update: if isAdmin() || (isAuthenticated() && currentUser().role == 'core_team')
        && request.resource.data.keys().hasAny(['name'])
        && request.resource.data.name is string;

      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // SECTIONS COLLECTION
    // ─────────────────────────────────────────────

    match /sections/{sectionId} {
      allow read: if isActiveMember();

      allow create, update: if isAdmin() || (isAuthenticated() && currentUser().role == 'core_team')
        && request.resource.data.keys().hasAll(['name', 'departmentId']);

      allow delete: if false;
    }

    // ─────────────────────────────────────────────
    // EVENTS COLLECTION
    // ─────────────────────────────────────────────

    match /events/{eventId} {
      // Any authenticated active user can read events
      allow read: if isActiveMember();

      // Only Admin or Core Team with access can create events
      allow create: if canManageEvents()
        && request.resource.data.keys().hasAll(['title', 'startDate', 'endDate'])
        && request.resource.data.title is string;

      // Only Admin or Core Team with access can update events
      allow update: if canManageEvents();

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
|---------|--------|
| Section Member role + section-scoped reads | 0.2+ |
| Department Manager role + dept-scoped writes | 0.3+ |
| Admin role + Discord-style role management | 0.4+ |
| Dynamic permission checks against `roles` collection | 0.4+ |
| Self-profile edits | 0.4+ |
| Read-scoped by department | 0.5+ |
| Hard deletes (Admin only) | 1.0 |

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
