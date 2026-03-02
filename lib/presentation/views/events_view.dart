import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/event.dart';
import '../viewmodels/event_detail_viewmodel.dart';
import '../viewmodels/events_viewmodel.dart';
import 'event_detail_view.dart';

/// EventsView – Displays active event list with status chips.
///
/// Clean Architecture: VIEW — reads from [EventsViewModel] via Provider.
class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  void initState() {
    super.initState();
    // Load events once when the view first mounts.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventsViewModel>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EventsViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text('Error: ${vm.error}'));
    }

    // Active events sorted most-recent first.
    final activeEvents = vm.events
        .where((e) => !e.archived)
        .toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    if (activeEvents.isEmpty) {
      return const Center(child: Text('No events yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeEvents.length,
      itemBuilder: (context, index) {
        return _EventCard(event: activeEvents[index]);
      },
    );
  }
}

/// Event card — shows title, start date, and status chip.
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
        onTap: () {
          final eventsVm = context.read<EventsViewModel>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => EventDetailViewModel(eventsVm.repo),
                child: EventDetailView(eventId: event.id),
              ),
            ),
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
                    _formatDate(event.startDate),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Status chip — colored by [EventStatus] enum.
class _StatusChip extends StatelessWidget {
  final EventStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    String label;
    switch (status) {
      case EventStatus.ongoing:
        chipColor = GDGColors.yellow;
        label = 'Ongoing';
        break;
      case EventStatus.completed:
        chipColor = GDGColors.green;
        label = 'Completed';
        break;
      case EventStatus.archived:
        chipColor = Colors.grey;
        label = 'Archived';
        break;
      default:
        chipColor = GDGColors.blue;
        label = 'Upcoming';
    }

    return Chip(
      label: Text(
        label,
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
