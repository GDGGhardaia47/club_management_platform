# AI Agent Guide — Club Management Platform

**Current Target Version:** `v0.1 (MVP)`
**Documentation Version:** `2.0`

This guide governs how AI agents (like GitHub Copilot) must behave when working on this project. Follow these rules strictly.

---

## Core Rules

### Rule 1 — Always Verify the Current Version First
Before implementing anything, check the current target version. As of this document: **`v0.1`**.

If the user has not explicitly said to upgrade the version, assume you are targeting **v0.1**.

```
Current target: v0.1 (MVP)
```

### Rule 2 — Never Implement Future Features Early
Features listed under "Future Features" or "v1.0 Target Features" in `01_functionalities.md` must **not** be implemented until their target version is active.

**Examples of what NOT to do in v0.1:**
- Do not add a task collection or task management UI
- Do not add an analytics dashboard
- Do not add activity logging
- Do not add a notification system
- Do not add Cloud Functions
- Do not implement a full RBAC system
- Do not add a manager or admin role
- Do not add event templates

If you are unsure whether a feature is in-scope, check `01_functionalities.md` under the v0.1 section. If it is not listed there, do not implement it.

### Rule 3 — Keep Implementations Minimal
Implement exactly what the current sprint requires. Do not add "nice to have" features, extra fields, or extra layers of abstraction.

**Examples:**
- A member form has only the fields defined in `04_data_models.md` for v0.1 — not future fields
- Services have only the methods needed now — not stubs for future methods
- ViewModels expose only the state needed for current views

### Rule 4 — Follow Incremental Expansion
When a new version is activated (e.g. a minor like 0.2, or a patch like 0.1.1), implement only what is listed for that version in `02_sprint_planning.md`. Do not skip ahead.

**Versioning convention:**
- `0.x` (e.g. 0.2, 0.3) — a new feature area milestone, ~1–2 sprints.
- `0.x.y` (e.g. 0.1.1, 0.2.1) — a small patch (UI polish, bug fixes) within a minor, a few days.

### Rule 5 — Respect Clean Architecture Boundaries
The architecture is: **Presentation → Domain ← Data → Firebase**

| Layer | Location | Rule |
|-------|----------|------|
| Domain models | `lib/domain/models/` | No Flutter, no Firebase imports |
| Repository interfaces | `lib/domain/repositories/` | Abstract only, no implementation |
| Datasources | `lib/data/datasources/` | All Firebase calls live here |
| Repository impls | `lib/data/repositories/` | Implement domain interfaces, use datasources |
| ViewModels | `lib/presentation/viewmodels/` | Use repository interfaces, no Firebase imports |
| Views | `lib/presentation/views/` | Use ViewModels only, no repos/datasources |
| Shared utilities | `lib/core/` | Theme, constants, typed exceptions |

Do not:
- Call Firestore from a ViewModel or View
- Import `firebase_*` in Domain layer files
- Bypass a repository by calling a datasource from a ViewModel

---

## Project Context

| Property | Value |
|----------|-------|
| App type | Internal mobile app (club management) |
| Framework | Flutter (mobile-first) |
| Backend | Firebase (Firestore + Auth) |
| State management | Provider (ChangeNotifier) |
| Routing | go_router |
| Target users | 30–100 internal club members |
| Scale | Single club, internal use only |
| Current version | v0.1 |

---

## Documentation Map

Always consult the relevant doc before implementing:

| Question | Document |
|----------|----------|
| Is this feature in-scope for v0.1? | `01_functionalities.md` |
| What sprint am I in? | `02_sprint_planning.md` |
| Where does this code go? | `03_architecture.md` |
| What fields does this model have? | `04_data_models.md` |
| Who can perform this action? | `05_security_rules.md` |
| What are the rules for this project? | `06_ai_agent_guide.md` (this file) |

### Reading Order for Any New Task
1. `06_ai_agent_guide.md` — verify version and rules
2. `02_sprint_planning.md` — identify current sprint tasks
3. `01_functionalities.md` — confirm feature is in-scope
4. `04_data_models.md` — use correct model fields
5. `03_architecture.md` — place code in correct layer/file
6. `05_security_rules.md` — apply correct permissions

---

## Code Conventions

### File Naming
- snake_case only: `member_service.dart`, `events_view.dart`
- Suffix by type: `_view.dart`, `_viewmodel.dart`, `_service.dart`, `_model.dart` (or just no suffix for models)

### Class Naming
- PascalCase: `MemberService`, `EventsViewModel`, `MembersView`

### Variable Naming
- camelCase: `memberId`, `isLoading`, `archivedAt`
- Boolean prefix: `isLoading`, `hasError`, `canArchive`, `archived`

### Dart/Flutter Patterns

#### Service
```dart
class MemberService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Member>> getMembers() async {
    final snap = await _db
        .collection('members')
        .where('archived', isEqualTo: false)
        .get();
    return snap.docs.map(Member.fromFirestore).toList();
  }
}
```

#### ViewModel
```dart
class MembersViewModel extends ChangeNotifier {
  final MemberRepository _repo;
  MembersViewModel(this._repo);

  List<Member> _members = [];
  bool _isLoading = false;
  String? _error;

  List<Member> get members => _members;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _members = await _repo.getActiveMembers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### View
```dart
class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MembersViewModel>().loadMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembersViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) return const Center(child: CircularProgressIndicator());
        if (vm.error != null) return Center(child: Text('Error: ${vm.error}'));
        if (vm.members.isEmpty) return const Center(child: Text('No members yet.'));
        return ListView.builder(
          itemCount: vm.members.length,
          itemBuilder: (_, i) => ListTile(title: Text(vm.members[i].name)),
        );
      },
    );
  }
}
```

---

## Decision-Making Framework

### When Asked to Add a Feature
1. Is it in `01_functionalities.md` under v0.1? → Implement it.
2. Is it listed under Future Features? → Refuse or flag it.
3. Is it ambiguous? → Default to the minimal interpretation. Ask if needed.

### When Architecture is Unclear
- Follow `03_architecture.md` folder structure
- Views never call Firebase directly — always through ViewModels → Repository interfaces
- ViewModels never import Firebase packages — only domain/repository interfaces
- Datasources are the ONLY files that import `firebase_*`
- Domain models use `fromJson`/`toJson` with plain maps, not Firestore types

### When a Model Field is Missing
- Only use fields defined in `04_data_models.md` for v0.1
- Do not add speculative fields for future use
- If a future field is needed early, update the data model doc and get approval

### When Permission Logic is Needed
- Use the two roles: `member`, `core_team`
- Use the three flags: `canManageMembers`, `canManageEvents`, `canArchive`
- These flags are computed from the `Member` model — not stored separately
- See `05_security_rules.md` for Firestore rules

---

## Common Tasks Reference

### Add a New View
1. Create `lib/presentation/views/<name>_view.dart`
2. Add route in `main.dart` router config
3. Add nav item to `main_shell.dart` if it's a top-level screen
4. Create or reuse a ViewModel for state

### Add a New ViewModel
1. Create `lib/presentation/viewmodels/<name>_viewmodel.dart`
2. Extend `ChangeNotifier`
3. Accept repository via constructor
4. Register in `MultiProvider` in `main.dart`

### Add a New Repository
1. Add abstract interface in `lib/domain/repositories/<name>_repository.dart`
2. Add datasource in `lib/data/datasources/<name>_remote_datasource.dart`
3. Add implementation in `lib/data/repositories/<name>_repository_impl.dart`
4. Wire in `main.dart`

### Add a New Model
1. Create `lib/domain/models/<name>.dart`
2. Follow the pattern in `04_data_models.md`
3. Implement `fromJson` and `toJson` using plain `Map<String, dynamic>` (no Firestore types)
4. Define any relevant enums in the same file

---

## What NOT to Do

- Do not use `setState` for shared/global state — use Provider
- Do not call Firestore from inside a View or ViewModel — always go through ViewModel → Repository → Datasource
- Do not import `firebase_*` in Domain layer files
- Do not bypass repository interface by calling datasource directly from ViewModel
- Do not add extra Firestore collections not listed in `04_data_models.md`
- Do not write Cloud Functions
- Do not add a task management UI
- Do not add analytics charts
- Do not use `BuildContext` inside a ViewModel or Repository
- Do not hard-code user IDs or test data in production code (use dummy data only behind a flag)

---

## Versioning Checklist

Before starting any implementation session, confirm:

- [ ] I know the current target version: **v0.1**
- [ ] I know which sprint I am in (check `02_sprint_planning.md`)
- [ ] I have confirmed the feature is in-scope for this version (check `01_functionalities.md`)
- [ ] I know where the code goes (check `03_architecture.md`)
- [ ] I know the correct model fields (check `04_data_models.md`)
- [ ] I know who has permission (check `05_security_rules.md`)

> **Version bump rules:**
> - A **minor bump** (0.1 → 0.2) means a significant new feature area is completed.
> - A **patch bump** (0.1 → 0.1.1) means a small fix or polish is applied.
> - Never skip versions. Never implement features from the next minor without explicit instruction.

---

> Build small. Ship fast. Improve continuously.
