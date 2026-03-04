# Club Management Platform — Functionalities

**Current Target:** `v0.1 (MVP)`
**Strategy:** Implement only what is listed under v0.1. Everything else is roadmap.

---

## Table of Contents
1. [v0.1 Core Features (MVP)](#v01-core-features-mvp)
2. [Future Features — Post 0.5](#future-features--post-05)
3. [v1.0 Target Features](#v10-target-features)

> **Versioning note:** `0.x` bumps (0.2, 0.3…) introduce new feature areas.
> `0.x.y` patches (0.1.1, 0.2.1…) are small fixes or polish within a minor version.

---

## v0.1 Core Features (MVP)

### 1. Authentication

#### Google Sign-In
- Sign in with Google (can start as mock / hardcoded, replace with Firebase Auth later)
- Member profile must already exist in Firestore before login is permitted — Core Team creates the account first
- On first login, the app looks up the member document by Firebase Auth UID and loads the existing profile
- If no matching member document exists, the user is shown an "access denied" screen — no auto-registration
- Logout clears session

#### Session
- Persistent session across app restarts
- Redirect unauthenticated users to login screen

#### Notes for v0.1
- **No self-registration of any kind — accounts are created exclusively by Admin (or Core Team with permissions in future versions). This is a permanent rule, not a v0.1-only restriction.**
- No email/password registration
- No email verification
- Forgot password flow available
- No multi-factor auth

---

### 2. Theme & Branding

- Light and Dark theme (Material 3)
- **Font**: Google Sans exclusively — no other typeface is permitted anywhere in the app
- Theme toggle in settings
- Consistent typography across all screens

#### Color Palette — Google Brand Colors with Material 3 Tonal Variants

Only Google brand colors and their tonal variants are used. No arbitrary colors.

| Role | Light | Dark |
|------|-------|------|
| **Primary** (Blue) | `#1A73E8` | `#669DF6` |
| Primary Container | `#D2E3FC` | `#0842A0` |
| **Secondary** (Green) | `#1E8E3E` | `#6DD58C` |
| Secondary Container | `#CEEAD6` | `#0A4020` |
| **Tertiary** (Yellow) | `#B06000` | `#FDD663` |
| Tertiary Container | `#FEF08A` | `#4A3500` |
| **Error** (Red) | `#D93025` | `#E57368` |
| Error Container | `#FAD2CF` | `#601410` |
| Surface | `#FFFBFE` | `#1C1B1F` |
| On Surface | `#1C1B1F` | `#E6E1E5` |

**Base hex references:**
- Blue: `#4285F4` — Red: `#DB4437` — Yellow: `#F4B400` — Green: `#0F9D58`

---

### 3. Member Management

#### Hierarchy
```
Department → Section → Members
```

#### Member Profile
**Fields (v0.1):**
- ID (auto-generated)
- Full Name
- Email
- Join Date
- Department (reference)
- Section (reference, optional)
- Role: `member` | `core_team`
- Status: `active` | `archived`
- Profile Picture URL (Google Drive link, optional)

#### Member CRUD (Core Team only)
- **Create**: Add new member with name, email, department, role
- **Read**: View member list and individual profiles
- **Update**: Edit member name, department, section, role
- **Archive**: Soft-delete member (set `archived: true`)

#### Member List View
- Show all active members
- Basic search by name
- Filter by department
- Tap to view member detail

#### Member Detail View
- Show full profile
- Show department and section
- Show role badge

#### Permissions
- All users: View member list and profiles
- Core Team: Create, edit, archive members

---

### 4. Department System

#### Structure
- A **Department** contains one or more **Sections**
- A **Section** contains members

#### Department Fields (v0.1)
- ID
- Name
- Description (optional)
- Status: `active` | `archived`

#### Section Fields (v0.1)
- ID
- Name
- Department ID (parent reference)
- Status: `active` | `archived`

#### Features
- View department list
- View department detail with its sections
- View section detail with its members
- Core Team: Create / edit departments and sections

---

### 5. Event Management

#### Event Fields (v0.1)
- ID
- Title
- Description
- Start Date
- End Date
- Status: `upcoming` | `ongoing` | `completed` | `archived`
- Created By (member ID)
- Created At

#### Event Features
- **List View**: Show all upcoming and ongoing events
- **Detail View**: Show full event info
- **Create** (Core Team only): Add new event with title, description, dates
- **Edit** (Core Team only): Update event details
- **Archive** (Core Team only): Soft-delete event

#### Archive View
- Separate archive section for both members and events
- Restore archived items (Core Team only)

---

### 6. Basic Permission System

Two roles only in v0.1:

| Role | Description |
|------|-------------|
| `member` | Regular club member |
| `core_team` | Can manage members and events |

Three permission flags:

| Flag | Granted To |
|------|-----------|
| `canManageMembers` | Core Team |
| `canManageEvents` | Core Team |
| `canArchive` | Core Team |

No complex RBAC. No Section Member, Department Manager, or Admin role in v0.1.
Full role hierarchy (`Member → Section Member → Department Manager → Core Team → Admin`) is introduced incrementally from v0.2 onward, using a Discord-style role permission system.

---

### 7. UI / UX

- Mobile-first Flutter layout
- Bottom navigation bar with: Home, Members, Events, Archive, Settings
- Clean cards for list views
- Consistent header/appbar

#### Screens (v0.1)
- Login
- Home (simple summary / welcome)
- Members list
- Member detail
- Member create/edit form (Core Team)
- Events list
- Event detail
- Event create/edit form (Core Team)
- Archive (members + events)
- Settings (theme toggle, logout)

---

## Future Features — Post 0.5

These features are **not in scope for v0.1**. Do not implement them prematurely.

### Task Management Engine
- Task CRUD
- Task assignment to members / departments / roles
- Task status tracking (Pending → In Progress → Completed)
- Task deadlines and reminders
- Task linking to events
- Google Drive attachment links per task

### Event Templates
- Reusable event templates with default tasks and timeline
- Instantiate events from templates
- Template management (Admin only)

### Meeting Management
- Schedule meetings within events
- Meeting notes links
- Attendance tracking

### Activity Logging System
- Automatic logging of all CRUD actions
- Before/After state snapshots
- Log viewing per entity
- Audit trail

### Notifications
- Deadline reminders
- Assignment notifications
- Status update alerts

### Advanced Member Tracking
- Promotion history
- Department change history
- Role change attribution

### Analytics Dashboard
- Overview metrics
- Task completion rates
- Event analytics
- Member activity charts

---

## v1.0 Target Features

These represent the full vision of the platform. They will be reached incrementally through 0.1.x → 0.9.x minor releases.

### Full RBAC System
- Role hierarchy: `Member → Section Member → Department Manager → Core Team → Admin`
- Role-based UI rendering
- Permission inheritance
- Dynamic permission updates on role change

### Discord-Style Role System (Admin)
- Admins can create custom roles with named permission sets
- Roles can be linked to events (e.g. event coordinator role) and tasks (e.g. task owner role)
- Permissions are assigned per role, not hardcoded per user
- Role assignment UI for managing member roles
- Admin-only: role creation, editing, deletion

### Full Department Permissions
- Department managers with scoped permissions
- Section-level access control

### Cloud Functions Automation
- Auto-assign tasks from templates
- Auto-notify on events and deadlines
- Role change automation

### Advanced Analytics
- Export reports (PDF, CSV)
- Custom date range queries
- Per-department and per-member breakdowns

### Multi-level Archive
- Bulk restore / delete
- Archive browsing with search and filters

### Performance Optimization
- Pagination for large lists
- Offline support
- Query optimization

### Search System
- Global search across members, events, tasks
- Filter combinations
- Sorting options

---

## Scope Summary

| Category | v0.1 | v0.2–v0.3 | v0.4–v0.5 | v0.6–v0.8 | v1.0 |
|----------|------|-----------|-----------|-----------|------|
| Auth | Google Sign-In (Core Team pre-creates accounts) | — | — | Email/password login (existing accounts only) | MFA, full OAuth |
| Roles | Member, Core Team | Section Member role | Department Manager role | Admin + Discord-style role creation | Custom roles linked to events & tasks |
| Members | CRUD, Dept/Section hierarchy | Attendance, event participation | Promotion & dept history | Role-change history | Full audit trail + analytics |
| Events | CRUD, listing, archive | Participation tracking | Meeting management | Event templates + coordinator roles | Full event engine |
| Tasks | Not included | Not included | Basic task CRUD | Full task engine | Task-role-event linking |
| Analytics | Not included | Basic stat cards | Per-section stats | Dept-level analytics | Full dashboard (PDF/CSV export) |
| Logging | Not included | Activity feed (basic) | Full audit trail | Per-entity logs | Complete audit system |
| Notifications | Not included | Not included | Deadline alerts | Assignment notifications | Full notification system |
| Cloud Functions | Not included | Not included | Not included | Role automation | Full automation pipeline |
| Search | Not included | Not included | Global search bar | Advanced filters + sorting | Full search system |
