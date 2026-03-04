# Club Management Platform — Technical Architecture

**Current Target Version:** `v0.1 (MVP)`
**Note:** This document reflects the Clean Architecture structure adopted from v0.1 onward. Do not deviate from it.

---

## Philosophy

> Adopt Clean Architecture from the start so the codebase can grow without rewrites.
> Keep each layer thin in v0.1, but keep the boundaries strict.
> Do not skip layers, even when they feel like boilerplate.

---

## Technology Stack (v0.1)

### Frontend
- **Framework**: Flutter (mobile-first, also runs on web/desktop)
- **Language**: Dart
- **State Management**: Provider (`ChangeNotifier`)
- **Routing**: `go_router`
- **Theme**: Material 3

### Backend
- **Platform**: Firebase
- **Authentication**: Firebase Authentication (Google Sign-In)
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage (for profile pictures) — external files use Google Drive links

### Development
- **Version Control**: Git / GitHub
- **Analysis**: `flutter analyze`, `flutter_lints`
- **Testing**: `flutter_test`

---

## Architecture Pattern — Clean Architecture

```
┌────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│  views/          — Flutter screens & widgets               │
│  viewmodels/     — ChangeNotifier; state only, no Firebase │
└───────────────────────────┬────────────────────────────────┘
                            │ calls (repository interfaces)
┌───────────────────────────▼────────────────────────────────┐
│                      Domain Layer                           │
│  models/         — Pure Dart entities (no Flutter, no FB)  │
│  repositories/   — Abstract interfaces (contracts)         │
└───────────────────────────┬────────────────────────────────┘
                            │ implemented by
┌───────────────────────────▼────────────────────────────────┐
│                       Data Layer                            │
│  repositories/impl/  — Concrete Firebase implementations   │
│  datasources/        — Raw Firestore / Auth calls          │
└───────────────────────────┬────────────────────────────────┘
                            │
┌───────────────────────────▼────────────────────────────────┐
│                    External (Firebase)                      │
│  Firestore, Firebase Auth                                  │
└────────────────────────────────────────────────────────────┘
```

**Dependency rule:** outer layers depend on inner layers, never the reverse.

| Layer | May depend on | May NOT depend on |
|-------|--------------|-------------------|
| Presentation | Domain | Data, Firebase |
| Domain (models, repo interfaces) | nothing | Presentation, Data, Firebase |
| Data | Domain | Presentation |

---

## Project Folder Structure (v0.1)

```
lib/
├── main.dart                          # Entry point, Provider setup, MaterialApp, router
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart             # ThemeData for light and dark modes
│   ├── constants/
│   │   └── app_constants.dart         # Route names, Firestore collection names, etc.
│   └── errors/
│       └── app_exception.dart         # Typed exception class (wraps Firebase errors)
│
├── domain/                            # Pure Dart — no Flutter, no Firebase imports
│   ├── models/                        # Entities / value objects
│   │   ├── member.dart
│   │   ├── department.dart
│   │   ├── section.dart
│   │   └── event.dart
│   └── repositories/                  # Abstract interfaces (contracts)
│       ├── member_repository.dart
│       ├── department_repository.dart
│       ├── section_repository.dart
│       ├── event_repository.dart
│       └── auth_repository.dart
│
├── data/                              # Firebase-specific implementations
│   ├── datasources/                   # Raw Firebase calls (Firestore / Auth)
│   │   ├── member_remote_datasource.dart
│   │   ├── department_remote_datasource.dart
│   │   ├── section_remote_datasource.dart
│   │   ├── event_remote_datasource.dart
│   │   └── auth_remote_datasource.dart
│   └── repositories/                  # Concrete implementations of domain interfaces
│       ├── member_repository_impl.dart
│       ├── department_repository_impl.dart
│       ├── section_repository_impl.dart
│       ├── event_repository_impl.dart
│       └── auth_repository_impl.dart
│
└── presentation/                      # Flutter UI
    ├── viewmodels/                    # ChangeNotifier — holds state, calls repositories
    │   ├── app_viewmodel.dart         # Auth state + current user
    │   ├── members_viewmodel.dart
    │   ├── member_detail_viewmodel.dart
    │   ├── departments_viewmodel.dart
    │   ├── events_viewmodel.dart
    │   ├── event_detail_viewmodel.dart
    │   └── archive_viewmodel.dart
    └── views/                         # Screens and widgets — no business logic
        ├── login_view.dart
        ├── main_shell.dart            # Bottom navigation shell
        ├── home_view.dart
        ├── members_view.dart
        ├── member_detail_view.dart
        ├── member_form_view.dart
        ├── departments_view.dart
        ├── events_view.dart
        ├── event_detail_view.dart
        ├── event_form_view.dart
        ├── archive_view.dart
        └── settings_view.dart
```

---

## Layer Responsibilities

### `domain/models/`
- Pure Dart classes: no `flutter`, no `firebase_*` imports.
- Contain `fromJson` / `toJson` helpers (plain maps only — no Firestore types).
- Define enums alongside their model.

```dart
// domain/models/member.dart
class Member {
  final String id;
  final String name;
  // ...

  factory Member.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

### `domain/repositories/`
- Abstract classes (interfaces) only — no implementation.
- Return typed domain objects, never `DocumentSnapshot` or raw maps.

```dart
// domain/repositories/member_repository.dart
abstract class MemberRepository {
  Future<List<Member>> getActiveMembers();
  Future<Member> getMemberById(String id);
  Future<void> createMember(Member member);
  Future<void> updateMember(Member member);
  Future<void> archiveMember(String id);
}
```

### `data/datasources/`
- Handle all raw Firebase API calls.
- Return raw `Map<String, dynamic>` data (converted from Firestore documents).
- Never imported by Presentation or Domain.

```dart
// data/datasources/member_remote_datasource.dart
class MemberRemoteDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchActiveMembers() async {
    final snap = await _db
        .collection('members')
        .where('archived', isEqualTo: false)
        .get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }
}
```

### `data/repositories/`
- Implement the domain interfaces.
- Use the datasource to get raw data, convert to domain models.

```dart
// data/repositories/member_repository_impl.dart
class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDatasource _ds;
  MemberRepositoryImpl(this._ds);

  @override
  Future<List<Member>> getActiveMembers() async {
    final raw = await _ds.fetchActiveMembers();
    return raw.map(Member.fromJson).toList();
  }
  // ...
}
```

### `presentation/viewmodels/`
- Extend `ChangeNotifier`.
- Receive repository via constructor (injected in `main.dart`).
- No Firebase imports — only domain imports.

```dart
// presentation/viewmodels/members_viewmodel.dart
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

### `presentation/views/`
- No Firebase, no repository, no datasource imports.
- Read state from ViewModels via `context.read` / `Consumer`.

```dart
// presentation/views/members_view.dart
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
        if (vm.error != null) return Center(child: Text(vm.error!));
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

## Dependency Injection (Manual — v0.1)

Repositories are wired in `main.dart` using `MultiProvider`. No DI framework for v0.1.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Data layer
  final memberDs       = MemberRemoteDatasource();
  final departmentDs   = DepartmentRemoteDatasource();
  final sectionDs      = SectionRemoteDatasource();
  final eventDs        = EventRemoteDatasource();
  final authDs         = AuthRemoteDatasource();

  // Repository implementations
  final memberRepo     = MemberRepositoryImpl(memberDs);
  final departmentRepo = DepartmentRepositoryImpl(departmentDs);
  final sectionRepo    = SectionRepositoryImpl(sectionDs);
  final eventRepo      = EventRepositoryImpl(eventDs);
  final authRepo       = AuthRepositoryImpl(authDs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppViewModel(authRepo)),
        ChangeNotifierProvider(create: (_) => MembersViewModel(memberRepo)),
        ChangeNotifierProvider(create: (_) => EventsViewModel(eventRepo)),
        ChangeNotifierProvider(create: (_) => DepartmentsViewModel(departmentRepo, sectionRepo)),
        ChangeNotifierProvider(create: (_) => ArchiveViewModel(memberRepo, eventRepo)),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Navigation

Using `go_router`:

```dart
final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isLoggedIn = context.read<AppViewModel>().isLoggedIn;
    if (!isLoggedIn && state.uri.path != '/login') return '/login';
    if (isLoggedIn && state.uri.path == '/login') return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginView()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',        builder: (_, __) => const HomeView()),
        GoRoute(path: '/members',     builder: (_, __) => const MembersView()),
        GoRoute(path: '/members/:id', builder: (_, s) => MemberDetailView(id: s.pathParameters['id']!)),
        GoRoute(path: '/members/new', builder: (_, __) => const MemberFormView()),
        GoRoute(path: '/events',      builder: (_, __) => const EventsView()),
        GoRoute(path: '/events/:id',  builder: (_, s) => EventDetailView(id: s.pathParameters['id']!)),
        GoRoute(path: '/events/new',  builder: (_, __) => const EventFormView()),
        GoRoute(path: '/archive',     builder: (_, __) => const ArchiveView()),
        GoRoute(path: '/settings',    builder: (_, __) => const SettingsView()),
      ],
    ),
  ],
);
```

---

## Firestore Collections (v0.1)

| Collection | Purpose |
|------------|---------|
| `members` | All user/member documents |
| `departments` | Department documents |
| `sections` | Section documents (sub-group of department) |
| `events` | Event documents |

No subcollections for v0.1. All references use top-level collection IDs.

---

## Theme

```dart
// lib/core/theme/app_theme.dart

class AppTheme {
  static const Color googleBlue   = Color(0xFF4285F4);
  static const Color googleRed    = Color(0xFFDB4437);
  static const Color googleYellow = Color(0xFFF4B400);
  static const Color googleGreen  = Color(0xFF0F9D58);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: googleBlue,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: googleBlue,
    brightness: Brightness.dark,
  );
}
```

---

## What Evolves in Later Versions

| Feature | v0.1 | Future |
|---------|------|--------|
| DI | Manual wiring in `main.dart` | get_it / injectable |
| State management | Provider | Riverpod (if complexity justifies) |
| Error handling | Try/catch in ViewModels | Typed Result / Either |
| Datasource | Firestore only | Local cache + Firestore sync |
| Testing | Manual / basic widget tests | Unit + integration tests |
| Cloud Functions | None | TypeScript Cloud Functions |
| Offline support | None | Firestore offline persistence |
| Pagination | None | Firestore cursors |
