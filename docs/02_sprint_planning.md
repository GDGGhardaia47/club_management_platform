# Club Management Platform — Sprint Planning

**Current Target Version:** `v0.1 (MVP)`
**Versioning Convention:** `MAJOR.MINOR.PATCH` — minor bumps (0.2, 0.3…) for new feature areas; patches (0.x.y) for small fixes.
**Timeline:** 3–4 weeks
**Total MVP Sprints:** 4

---

## Overview

### Phase 1 — MVP (v0.1)

Four focused sprints. Each sprint is approximately 1 week.

| Sprint | Focus | Duration |
|--------|-------|----------|
| Sprint 1 | Authentication + Project Structure | Week 1 |
| Sprint 2 | Member Management | Week 2 |
| Sprint 3 | Event Management | Week 3 |
| Sprint 4 | UI Polish + Testing + Archive | Week 4 |

### Phase 2 — Iterative Growth (0.x and 0.x.y)

After v0.1 ships, growth follows two levels:
- **Minor versions** (0.2, 0.3, …): significant new feature areas, each ~1–2 sprints.
- **Patch versions** (0.x.1, 0.x.2, …): small fixes and UI polish within a minor, ~few days.

---

## Phase 1 — MVP Sprints

---

## Sprint 1 — Authentication + Project Structure (Week 1)

### Goals
- Set up Flutter project structure
- Implement Google Sign-In (mock or real)
- Set up Firebase project (Firestore, Auth)
- Create basic navigation shell
- Apply theme (Material 3, Google brand colors)

### Tasks

#### 1.1 Flutter Project Setup
- [ ] Clean up default Flutter template
- [ ] Set up folder structure per `03_architecture.md`
- [ ] Add required dependencies to `pubspec.yaml` (`firebase_core`, `firebase_auth`, `cloud_firestore`, `provider`, `go_router`)
- [ ] Set up `AppTheme` with light/dark modes and Google brand colors
- [ ] Create `main.dart` entry point with `MaterialApp` + theme

#### 1.2 Firebase Setup
- [ ] Create Firebase project
- [ ] Enable Firestore + Firebase Authentication (Google provider)
- [ ] Connect Flutter app to Firebase (`google-services.json` / `GoogleService-Info.plist`)
- [ ] Create initial Firestore `members` collection with a test document

#### 1.3 Authentication
- [ ] Create `AuthService` with `signInWithGoogle()` and `signOut()`
- [ ] Create `AuthViewModel` (or Provider) to expose auth state
- [ ] Build `LoginView` with Google Sign-In button
- [ ] Auto-redirect authenticated users to home, unauthenticated to login
- [ ] Persist session across restarts

#### 1.4 Navigation Shell
- [ ] Implement `MainShell` with bottom navigation bar
- [ ] Navigation items: Home, Members, Events, Archive, Settings
- [ ] Set up `go_router` with all top-level routes
- [ ] Placeholder screens for all sections

#### 1.5 Settings Screen (Stub)
- [ ] Theme toggle (light/dark)
- [ ] Logout button
- [ ] Display logged-in user name/email

### Deliverables
- Working login / logout flow
- Bottom navigation with placeholder screens
- Light/dark theme applied globally
- Firebase connected

---

## Sprint 2 — Member Management (Week 2)

### Goals
- Implement full Member CRUD (Core Team only)
- Department + Section hierarchy
- Member list and detail views

### Tasks

#### 2.1 Data Models
- [ ] Create `Member` Dart model (see `04_data_models.md`)
- [ ] Create `Department` Dart model
- [ ] Create `Section` Dart model
- [ ] Implement `fromFirestore` / `toFirestore` for each

#### 2.2 Services
- [ ] Create `MemberService`: `getMembers()`, `getMemberById()`, `createMember()`, `updateMember()`, `archiveMember()`
- [ ] Create `DepartmentService`: `getDepartments()`, `getSectionsByDepartment()`

#### 2.3 ViewModels / Providers
- [ ] `MembersViewModel`: manages member list state, loading, error
- [ ] `MemberDetailViewModel`: manages single member state
- [ ] `DepartmentsViewModel`: manages department + section list

#### 2.4 Views
- [ ] `MembersView`: paginated list of active members, search by name, filter by department
- [ ] `MemberDetailView`: full profile display
- [ ] `MemberFormView`: create / edit form (Core Team only) — name, email, department, section, role
- [ ] `DepartmentsView`: list departments and their sections
- [ ] `SectionDetailView`: list members in a section

#### 2.5 Permissions
- [ ] Check `canManageMembers` flag before showing create/edit/archive buttons
- [ ] Hide management actions from regular members

### Deliverables
- Members can be listed, created, viewed, edited, and archived by Core Team
- Department → Section → Members hierarchy navigable
- Regular members can browse but not edit

---

## Sprint 3 — Event Management (Week 3)

### Goals
- Implement full Event CRUD (Core Team only)
- Event listing and detail views
- Archive system for events

### Tasks

#### 3.1 Data Models
- [ ] Create `Event` Dart model (see `04_data_models.md`)
- [ ] Implement `fromFirestore` / `toFirestore`

#### 3.2 Services
- [ ] Create `EventService`: `getEvents()`, `getEventById()`, `createEvent()`, `updateEvent()`, `archiveEvent()`
- [ ] Create `ArchiveService`: `getArchivedMembers()`, `getArchivedEvents()`, `restoreMember()`, `restoreEvent()`

#### 3.3 ViewModels / Providers
- [ ] `EventsViewModel`: manages event list (active, filtered)
- [ ] `EventDetailViewModel`: manages single event
- [ ] `ArchiveViewModel`: manages archived items

#### 3.4 Views
- [ ] `EventsView`: list upcoming + ongoing events, cards with date + title
- [ ] `EventDetailView`: full event info (title, description, date range, status)
- [ ] `EventFormView`: create / edit form (Core Team only) — title, description, start date, end date
- [ ] `ArchiveView`: tabbed view showing archived members + archived events, restore button (Core Team)

#### 3.5 Permissions
- [ ] Check `canManageEvents` before showing create/edit buttons
- [ ] Check `canArchive` before showing archive/restore buttons

### Deliverables
- Events can be created, viewed, edited, and archived by Core Team
- All users can browse active events
- Archive view shows archived members and events
- Core Team can restore from archive

---

## Sprint 4 — UI Polish + Testing (Week 4)

### Goals
- Polish all screens for a clean, professional look
- Fix bugs found during testing
- Ensure consistent theming
- Validate all user flows end-to-end

### Tasks

#### 4.1 UI Polish
- [ ] Consistent card styles across all list views
- [ ] Consistent form field styling
- [ ] Empty state illustrations / messages for all lists
- [ ] Loading indicators for all async operations
- [ ] Error state feedback (snackbars / dialogs)
- [ ] Smooth theme transitions (light ↔ dark)
- [ ] Home screen: welcome card with user name + quick stats (member count, upcoming events)

#### 4.2 Navigation Improvements
- [ ] Back navigation in all detail and form views
- [ ] Correct bottom nav active state
- [ ] Deep link handling (optional)

#### 4.3 Bug Fixing
- [ ] Auth edge cases (signed-in user already in app, auth error handling)
- [ ] Firestore permission errors surfaced clearly
- [ ] Form validation messages

#### 4.4 Testing
- [ ] Core Team flows: create/edit/archive member, create/edit/archive event
- [ ] Regular member flows: browse members, browse events, view archive (read-only)
- [ ] Login/logout flow
- [ ] Theme toggle persists across restarts

#### 4.5 Code Cleanup
- [ ] Remove placeholder / stub screens
- [ ] Remove debug prints
- [ ] Run `flutter analyze` and resolve all warnings

### Deliverables
- v0.1 fully functional and polished
- All user flows working
- No major bugs
- Ready to ship internally

---

## Phase 2 — Iterative Growth (0.x / 0.x.y)

Only begin after v0.1 is stable. Minor versions introduce new feature areas; patches are small fixes.

| Version  | Type  | Focus | Key Tasks |
|----------|-------|-------|-----------|
| **0.1.1** | patch | Member filtering polish | Advanced filter panel, member status badges |
| **0.1.2** | patch | UI consistency fixes | Card styles, empty states, loading skeletons |
| **0.2**   | minor | Section permissions + event participation | Section leads, mark participants |
| **0.2.1** | patch | Attendance tracking | Attendance list per event |
| **0.3**   | minor | Archive improvements + activity feed | Search/sort in archive, recent-actions log |
| **0.3.1** | patch | Role titles enhancement | Custom role display names and badges |
| **0.4**   | minor | Search & filtering | Global search bar, multi-filter combinations |
| **0.5**   | minor | Dashboard overview | Stat cards: member count, upcoming events |
| **0.5.x** | patch | Refactoring & performance | Code cleanup, query optimization, pagination |

---

## Scope Reduction Summary

| Before (v1 planning) | Now (v0.1 MVP) |
|----------------------|----------------|
| 14 sprints | 4 MVP sprints |
| 12–14 weeks | 3–4 weeks |
| 100+ features | Focused MVP core |
| Full RBAC | Two roles + permission flags |
| Task engine | Not included |
| Analytics | Not included |
| Cloud Functions | Not included |
