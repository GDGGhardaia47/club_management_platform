import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/event.dart';
import 'event_detail_view.dart';

/// EventsView – Displays event list with status chips.
///
/// MVVM Role: VIEW
/// - Receives events list from parent (via EventsViewModel data)
/// - Navigates to EventDetailView on tap
/// - Pure UI — no state management
class EventsView extends StatelessWidget {
  final List<Event> events;

  const EventsView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // Filter out archived, sort most recent first
    final activeEvents = events.where((e) => !e.isArchived).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeEvents.length,
      itemBuilder: (context, index) {
        return _EventCard(event: activeEvents[index]);
      },
    );
  }
}

/// Event card — shows title, date, location, and status chip.
class _EventCard extends StatelessWidget {
  final Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Navigate to Event Detail View
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetailView(event: event)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusChip(status: event.status),
                ],
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

/// Status chip — colored by event status.
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    switch (status) {
      case 'Ongoing':
        chipColor = GDGColors.yellow;
        break;
      case 'Done':
        chipColor = GDGColors.green;
        break;
      default:
        chipColor = GDGColors.blue;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: chipColor == GDGColors.yellow ? Colors.black87 : Colors.white,
        ),
      ),
      backgroundColor: chipColor,
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
