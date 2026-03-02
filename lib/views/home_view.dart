import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/event.dart';
import '../viewmodels/app_viewmodel.dart';

/// HomeView – Dashboard showing welcome, upcoming events, section info, quick actions.
///
/// MVVM Role: VIEW
/// - Receives [AppViewModel] for user info and tab switching
/// - Receives [events] list from parent (MainShell passes EventsViewModel data)
/// - No state management — purely declarative UI
class HomeView extends StatelessWidget {
  final AppViewModel appViewModel;
  final List<Event> events;

  /// Callback to switch tabs in the parent MainShell.
  final ValueChanged<int> onSwitchTab;

  const HomeView({
    super.key,
    required this.appViewModel,
    required this.events,
    required this.onSwitchTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get upcoming events (not Done), sorted by nearest date
    final upcomingEvents = events.where((e) => e.status != 'Done').toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(theme),
          const SizedBox(height: 16),
          _buildUpcomingEventsCard(theme, upcomingEvents),
          const SizedBox(height: 16),
          _buildSectionCard(theme),
          const SizedBox(height: 16),
          _buildQuickActions(context, theme),
        ],
      ),
    );
  }

  // ── Welcome Card with gradient ──
  Widget _buildWelcomeCard(ThemeData theme) {
    return Card(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [GDGColors.blue, GDGColors.blue.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ...([GDGColors.red, GDGColors.yellow, GDGColors.green]).map(
                  (c) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'GDG Ghardaïa',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome,',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            Text(
              appViewModel.currentUserName,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Upcoming Events Card ──
  Widget _buildUpcomingEventsCard(ThemeData theme, List<Event> upcoming) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: GDGColors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Events',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (upcoming.isEmpty)
              const Text('No upcoming events.')
            else
              ...upcoming
                  .take(3)
                  .map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          _statusDot(event.status),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${_formatDate(event.date)} · ${event.location}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // ── My Section Card ──
  Widget _buildSectionCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group_work, color: GDGColors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'My Section',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _infoRow(theme, 'Section', 'Mobile Section'),
            _infoRow(theme, 'Department', 'Development Department'),
            _infoRow(theme, 'Role', 'Core Team – Lead'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Buttons ──
  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.people,
                label: 'View Members',
                color: GDGColors.blue,
                onTap: () => onSwitchTab(1), // Switch to Members tab
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.event,
                label: 'View Events',
                color: GDGColors.red,
                onTap: () => onSwitchTab(2), // Switch to Events tab
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusDot(String status) {
    Color color;
    switch (status) {
      case 'Ongoing':
        color = GDGColors.yellow;
        break;
      case 'Done':
        color = GDGColors.green;
        break;
      default:
        color = GDGColors.blue;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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

/// Quick action button widget.
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
