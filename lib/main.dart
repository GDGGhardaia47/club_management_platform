import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ── Core ──
import 'core/theme/app_theme.dart';

// ── Data layer ──
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/member_remote_datasource.dart';
import 'data/datasources/department_remote_datasource.dart';
import 'data/datasources/section_remote_datasource.dart';
import 'data/datasources/event_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/member_repository_impl.dart';
import 'data/repositories/department_repository_impl.dart';
import 'data/repositories/section_repository_impl.dart';
import 'data/repositories/event_repository_impl.dart';

// ── Presentation layer ──
import 'presentation/viewmodels/app_viewmodel.dart';
import 'presentation/viewmodels/members_viewmodel.dart';
import 'presentation/viewmodels/departments_viewmodel.dart';
import 'presentation/viewmodels/events_viewmodel.dart';
import 'presentation/viewmodels/archive_viewmodel.dart';
import 'presentation/views/login_view.dart';
import 'presentation/views/main_shell.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// GDG Ghardaïa – Club Management Platform (v0.1)
/// Architecture: Clean Architecture
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Layer Responsibilities:
///   PRESENTATION  → Views + ViewModels (Flutter/Provider)
///   DOMAIN        → Models + Repository interfaces (pure Dart)
///   DATA          → Datasources + Repository implementations
///   EXTERNAL      → Firebase / HTTP (stub stubs in v0.1)
///
/// Folder Structure:
///   lib/
///   ├── main.dart                     ← DI wiring + app entry point
///   ├── core/theme/                   ← Material 3 theme config
///   ├── core/constants/               ← Route paths, collection names
///   ├── core/errors/                  ← Typed exceptions
///   ├── domain/models/                ← Entity classes (pure Dart)
///   ├── domain/repositories/          ← Abstract repository interfaces
///   ├── data/datasources/             ← Remote data access (stub/Firebase)
///   ├── data/repositories/            ← Repository implementations
///   └── presentation/viewmodels/      ← ChangeNotifier ViewModels
///       presentation/views/           ← Stateless/Stateful widgets
///
/// Dependency Injection:
///   All repos are wired here via MultiProvider.
///   ViewModels receive their repos via constructor (no service locator).
///   Only datasources may import firebase_* packages.
///
void main() {
  // ── Datasources ──
  final authDs    = AuthRemoteDatasource();
  final memberDs  = MemberRemoteDatasource();
  final deptDs    = DepartmentRemoteDatasource();
  final sectionDs = SectionRemoteDatasource();
  final eventDs   = EventRemoteDatasource();

  // ── Repository implementations ──
  final authRepo    = AuthRepositoryImpl(authDs);
  final memberRepo  = MemberRepositoryImpl(memberDs);
  final deptRepo    = DepartmentRepositoryImpl(deptDs);
  final sectionRepo = SectionRepositoryImpl(sectionDs);
  final eventRepo   = EventRepositoryImpl(eventDs);

  runApp(
    MultiProvider(
      providers: [
        // Global state — auth, theme, role simulation
        ChangeNotifierProvider(create: (_) => AppViewModel(authRepo)),

        // Feature ViewModels — each owns one or more repos
        ChangeNotifierProvider(create: (_) => MembersViewModel(memberRepo)),
        ChangeNotifierProvider(
          create: (_) => DepartmentsViewModel(deptRepo, sectionRepo),
        ),
        ChangeNotifierProvider(create: (_) => EventsViewModel(eventRepo)),
        ChangeNotifierProvider(
          create: (_) => ArchiveViewModel(memberRepo, eventRepo),
        ),
      ],
      child: const GDGApp(),
    ),
  );
}

/// Root widget — watches [AppViewModel] for theme and auth state.
class GDGApp extends StatelessWidget {
  const GDGApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appVm = context.watch<AppViewModel>();

    return MaterialApp(
      title: 'GDG Ghardaïa',
      debugShowCheckedModeBanner: false,

      // ── Theme ──
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: appVm.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ── Navigation: Login → Main Shell ──
      home: appVm.isLoggedIn
          ? const MainShell()
          : LoginView(appViewModel: appVm),
    );
  }
}

