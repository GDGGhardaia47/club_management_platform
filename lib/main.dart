import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'viewmodels/app_viewmodel.dart';
import 'views/login_view.dart';
import 'views/main_shell.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// GDG Ghardaïa – Club Management Platform (MVP v0.1)
/// Architecture: MVVM (Model-View-ViewModel)
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// MVVM Layer Responsibilities:
///   MODEL      → Data classes (Member, Event)
///   VIEWMODEL  → Business logic & state (ChangeNotifier)
///   VIEW       → Pure UI (widgets that consume ViewModels)
///   SERVICE    → Data fetching (GDG API, dummy data)
///
/// Folder Structure:
///   lib/
///   ├── main.dart              ← App entry point (this file)
///   ├── theme/app_theme.dart   ← Material 3 theme config
///   ├── models/                ← Data models (Member, Event)
///   ├── viewmodels/            ← State & logic (ChangeNotifier)
///   ├── views/                 ← UI screens (consume ViewModels)
///   └── services/              ← Data services (GDG, dummy data)
///
/// Navigation Flow:
///   1. App starts → LoginView (mock Google Sign-In)
///   2. After login → MainShell (NavigationBar with 4 tabs)
///     ├── HomeView     – Welcome, upcoming events, quick actions
///     ├── MembersView  – Department → Section → Members hierarchy
///     ├── EventsView   – Event list with status chips
///     └── SettingsView – Theme toggle, core team simulation
///   3. Members → tap → MemberDetailView
///   4. Events → tap → EventDetailView
///   5. AppBar menu → ArchiveView (static lists)
///
void main() {
  runApp(const GDGApp());
}

/// Root widget — creates the AppViewModel and passes it down.
/// Uses ListenableBuilder to react to ViewModel changes.
class GDGApp extends StatefulWidget {
  const GDGApp({super.key});

  @override
  State<GDGApp> createState() => _GDGAppState();
}

class _GDGAppState extends State<GDGApp> {
  // Top-level ViewModel — manages auth, theme, core team state
  late final AppViewModel _appViewModel;

  @override
  void initState() {
    super.initState();
    _appViewModel = AppViewModel();
  }

  @override
  void dispose() {
    _appViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder rebuilds when AppViewModel notifies (login, theme change)
    return ListenableBuilder(
      listenable: _appViewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'GDG Ghardaïa',
          debugShowCheckedModeBanner: false,

          // ── Theme from ViewModel ──
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: _appViewModel.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // ── Navigation: Login → Main Shell ──
          home: _appViewModel.isLoggedIn
              ? MainShell(appViewModel: _appViewModel)
              : LoginView(appViewModel: _appViewModel),
        );
      },
    );
  }
}
