import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/event.dart';
import '../viewmodels/event_detail_viewmodel.dart';

/// EventDetailView – Full details for a single event.
///
/// Clean Architecture: VIEW — consumes [EventDetailViewModel] from Provider.
/// The ViewModel is provisioned by the caller (e.g. EventsView wraps a
/// `ChangeNotifierProvider` for [EventDetailViewModel] before pushing this route).
class EventDetailView extends StatefulWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  @override
  void initState() {
    super.initState();
    // Load event data after the first frame so Provider is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventDetailViewModel>().loadEvent(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<EventDetailViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return Center(child: Text('Error: ${vm.error}'));
          }
          final event = vm.event;
          if (event == null) {
            return const Center(child: Text('Event not found.'));
          }
          return _buildContent(theme, event);
        },
      ),
    );
  }

  Widget _buildContent(ThemeData theme, Event event) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(theme, event),
          const SizedBox(height: 16),
          if (event.description != null) ...[
            _buildSection(
              theme,
              Icons.description,
              'Description',
              child: Text(
                event.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildSection(
            theme,
            Icons.calendar_today,
            'Schedule',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start: ${_formatDate(event.startDate)}',
                    style: theme.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('End: ${_formatDate(event.endDate)}',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            theme,
            Icons.person,
            'Organiser',
            child: Text(event.createdBy, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme, Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _StatusChip(status: event.status),
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
                Icon(icon, color: GDGColors.blue, size: 20),
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

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
