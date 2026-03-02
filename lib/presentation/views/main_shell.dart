import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_viewmodel.dart';
import '../viewmodels/archive_viewmodel.dart';
import 'home_view.dart';
import 'members_view.dart';
import 'events_view.dart';
import 'settings_view.dart';
import 'archive_view.dart';

/// MainShell – Primary scaffold with Material 3 NavigationBar (4 tabs).
///
/// Clean Architecture: VIEW — reads ViewModels from Provider, no direct repo access.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  /// Switch to a specific tab (called by HomeView quick actions).
  void _switchTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    const tabTitles = ['Home', 'Members', 'Events', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        title: Text(tabTitles[_currentIndex]),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'archive') {
                final archiveVm = context.read<ArchiveViewModel>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: archiveVm,
                      child: const ArchiveView(),
                    ),
                  ),
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
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
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
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeView(onSwitchTab: _switchTab);
      case 1:
        return const MembersView();
      case 2:
        return const EventsView();
      case 3:
        return SettingsView(appViewModel: context.read<AppViewModel>());
      default:
        return const Center(child: Text('Unknown tab'));
    }
  }
}
