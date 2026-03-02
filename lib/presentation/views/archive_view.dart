import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/member.dart';
import '../../domain/models/event.dart';
import '../viewmodels/archive_viewmodel.dart';

/// ArchiveView – Tabbed view for archived members and events.
///
/// Clean Architecture: VIEW — consumes [ArchiveViewModel] from Provider.
/// Caller must provision a `ChangeNotifierProvider` for [ArchiveViewModel]
/// before pushing this route (see MainShell).
class ArchiveView extends StatefulWidget {
  const ArchiveView({super.key});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArchiveViewModel>().loadArchive();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ArchiveViewModel>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Members'),
              Tab(icon: Icon(Icons.event), text: 'Events'),
            ],
            indicatorColor: GDGColors.blue,
          ),
        ),
        body: Builder(
          builder: (_) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text('Error: ${vm.error}'));
            }
            return TabBarView(
              children: [
                _buildArchivedMembersList(theme, vm, vm.archivedMembers),
                _buildArchivedEventsList(theme, vm, vm.archivedEvents),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildArchivedMembersList(
    ThemeData theme,
    ArchiveViewModel vm,
    List<Member> members,
  ) {
    if (members.isEmpty) {
      return const Center(child: Text('No archived members.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final m = members[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              child: Text(
                m.name[0],
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(m.name),
            subtitle: Text(
              '${m.role == MemberRole.coreTeam ? 'Core Team' : 'Member'} · Archived',
            ),
            trailing: TextButton(
              onPressed: () => vm.restoreMember(m.id),
              child: const Text('Restore'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArchivedEventsList(
    ThemeData theme,
    ArchiveViewModel vm,
    List<Event> events,
  ) {
    if (events.isEmpty) {
      return const Center(child: Text('No archived events.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.grey),
            title: Text(e.title),
            subtitle: Text(_formatDate(e.startDate)),
            trailing: TextButton(
              onPressed: () => vm.restoreEvent(e.id),
              child: const Text('Restore'),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
