import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/dummy_data.dart';

/// ArchiveView – Tabbed view for archived members and events.
///
/// MVVM Role: VIEW
/// - Reads static archive data directly from DummyData
/// - No ViewModel needed (static placeholder data)
/// - Accessible from AppBar menu in MainShell
class ArchiveView extends StatelessWidget {
  const ArchiveView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final archivedMembers = DummyData.getArchivedMembers();
    final archivedEvents = DummyData.getArchivedEvents();

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
        body: TabBarView(
          children: [
            _buildArchivedMembersList(theme, archivedMembers),
            _buildArchivedEventsList(theme, archivedEvents),
          ],
        ),
      ),
    );
  }

  Widget _buildArchivedMembersList(ThemeData theme, List archivedMembers) {
    if (archivedMembers.isEmpty) {
      return const Center(child: Text('No archived members.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedMembers.length,
      itemBuilder: (context, index) {
        final m = archivedMembers[index];
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
            subtitle: Text('${m.roleTitle} · ${m.section}'),
            trailing: Chip(
              label: const Text('Archived', style: TextStyle(fontSize: 11)),
              backgroundColor: Colors.grey.withValues(alpha: 0.15),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }

  Widget _buildArchivedEventsList(ThemeData theme, List archivedEvents) {
    if (archivedEvents.isEmpty) {
      return const Center(child: Text('No archived events.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: archivedEvents.length,
      itemBuilder: (context, index) {
        final e = archivedEvents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.grey),
            title: Text(e.title),
            subtitle: Text('${_formatDate(e.date)} · ${e.location}'),
            trailing: Chip(
              label: const Text('Archived', style: TextStyle(fontSize: 11)),
              backgroundColor: Colors.grey.withValues(alpha: 0.15),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
