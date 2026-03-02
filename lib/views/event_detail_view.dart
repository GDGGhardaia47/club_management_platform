import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/event.dart';
import '../services/dummy_data.dart';
import '../viewmodels/event_detail_viewmodel.dart';

/// EventDetailView – Full details for a single event.
///
/// MVVM Role: VIEW
/// - Creates its own [EventDetailViewModel] for organizer toggle state
/// - Receives [Event] model as read-only data
/// - Uses ListenableBuilder to react to ViewModel changes
class EventDetailView extends StatefulWidget {
  final Event event;

  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  // Each detail view creates its own ViewModel instance
  late final EventDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EventDetailViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = widget.event;
    final allMembers = DummyData.getMembers();

    // Find assigned members by ID
    final assignedMembers = allMembers
        .where((m) => event.assignedMemberIds.contains(m.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(theme, event),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              Icons.description,
              'Description',
              child: Text(event.description, style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              Icons.business,
              'Departments Involved',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: event.departmentsInvolved
                    .map(
                      (d) => Chip(
                        label: Text(d, style: const TextStyle(fontSize: 12)),
                        backgroundColor: GDGColors.blue.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              Icons.folder_outlined,
              'Sections Involved',
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: event.sectionsInvolved
                    .map(
                      (s) => Chip(
                        label: Text(s, style: const TextStyle(fontSize: 12)),
                        backgroundColor: GDGColors.green.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              theme,
              Icons.people,
              'Assigned Members',
              child: Column(
                children: assignedMembers
                    .map(
                      (m) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: GDGColors.blue.withValues(
                            alpha: 0.15,
                          ),
                          child: Text(
                            m.name[0],
                            style: const TextStyle(
                              color: GDGColors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        title: Text(m.name, style: theme.textTheme.bodyMedium),
                        subtitle: Text(
                          m.roleTitle,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // ── Organizer Toggle — uses ListenableBuilder to react to ViewModel ──
            ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final confirmed = _viewModel.isConfirmedOrganizer;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: confirmed
                      ? OutlinedButton.icon(
                          onPressed: _viewModel.toggleOrganizer,
                          icon: const Icon(
                            Icons.check_circle,
                            color: GDGColors.green,
                          ),
                          label: const Text('Confirmed as Organizer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: GDGColors.green,
                            side: const BorderSide(color: GDGColors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      : FilledButton.icon(
                          onPressed: _viewModel.toggleOrganizer,
                          icon: const Icon(Icons.volunteer_activism),
                          label: const Text('Confirm as Organizer'),
                          style: FilledButton.styleFrom(
                            backgroundColor: GDGColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme, Event event) {
    Color statusColor;
    switch (event.status) {
      case 'Ongoing':
        statusColor = GDGColors.yellow;
        break;
      case 'Done':
        statusColor = GDGColors.green;
        break;
      default:
        statusColor = GDGColors.blue;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(
                event.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: statusColor == GDGColors.yellow
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              backgroundColor: statusColor,
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(event.date),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.location,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    IconData icon,
    String title, {
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: GDGColors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
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
