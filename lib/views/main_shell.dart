import 'package:flutter/material.dart';
import '../viewmodels/app_viewmodel.dart';
import '../viewmodels/events_viewmodel.dart';
import 'home_view.dart';
import 'members_view.dart';
import 'events_view.dart';
import 'settings_view.dart';
import 'archive_view.dart';

/// MainShell – Primary scaffold with Material 3 NavigationBar (4 tabs).
///
/// MVVM Role: VIEW (top-level navigation container)
/// - Receives [AppViewModel] for global state
/// - Owns [EventsViewModel] for event data loading
/// - Uses ListenableBuilder to react to ViewModel changes
/// - Delegates all state mutations to ViewModels
class MainShell extends StatefulWidget {
  final AppViewModel appViewModel;

  const MainShell({super.key, required this.appViewModel});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Current navigation tab index (UI-only state, stays in View)
  int _currentIndex = 0;

  // EventsViewModel — created and owned by this view
  late final EventsViewModel _eventsViewModel;

  @override
  void initState() {
    super.initState();
    _eventsViewModel = EventsViewModel();
    _eventsViewModel.loadEvents(); // Start fetching events
  }

  @override
  void dispose() {
    _eventsViewModel.dispose();
    super.dispose();
  }

  /// Switch to a specific tab (called by HomeView quick actions).
  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    const tabTitles = ['Home', 'Members', 'Events', 'Settings'];

    // ListenableBuilder reacts to both AppViewModel and EventsViewModel changes
    return ListenableBuilder(
      listenable: Listenable.merge([widget.appViewModel, _eventsViewModel]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(tabTitles[_currentIndex]),
            actions: [
              // Archive menu — accessible from AppBar
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'archive') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArchiveView()),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('Archive'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Body: loading indicator or current tab view ──
          body: _eventsViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(),

          // ── Material 3 NavigationBar ──
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outlined),
                selectedIcon: Icon(Icons.people),
                label: 'Members',
              ),
              NavigationDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon: Icon(Icons.event),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds the current tab's view, passing ViewModels as needed.
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeView(
          appViewModel: widget.appViewModel,
          events: _eventsViewModel.events,
          onSwitchTab: _switchTab,
        );
      case 1:
        return MembersView(
          members: widget.appViewModel.members,
          isCoreTeam: widget.appViewModel.isCoreTeam,
        );
      case 2:
        return EventsView(events: _eventsViewModel.events);
      case 3:
        return SettingsView(appViewModel: widget.appViewModel);
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }
}
