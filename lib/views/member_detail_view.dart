import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/member.dart';

/// MemberDetailView – Shows full details for a single member.
///
/// MVVM Role: VIEW
/// - Receives a [Member] model and core team flag
/// - Pure UI — no ViewModel needed (read-only data)
class MemberDetailView extends StatelessWidget {
  final Member member;
  final bool isCoreTeam;

  const MemberDetailView({
    super.key,
    required this.member,
    required this.isCoreTeam,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Member Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(theme),
            const SizedBox(height: 24),
            _buildInfoCard(
              theme,
              Icons.business,
              'Department',
              member.department,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme,
              Icons.folder_outlined,
              'Section',
              member.section,
            ),
            const SizedBox(height: 8),
            _buildInfoCard(theme, Icons.badge, 'Role', member.roleTitle),
            const SizedBox(height: 8),
            _buildInfoCard(
              theme,
              Icons.calendar_today,
              'Join Date',
              _formatDate(member.joinDate),
            ),
            const SizedBox(height: 24),
            _buildActivitySection(theme),
          ],
        ),
      ),
      // FAB for core team
      floatingActionButton: isCoreTeam
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add Member (mock action)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Add Member'),
            )
          : null,
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    Color avatarColor;
    switch (member.department) {
      case 'Development Department':
        avatarColor = GDGColors.blue;
        break;
      case 'Design Department':
        avatarColor = GDGColors.red;
        break;
      default:
        avatarColor = GDGColors.yellow;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: avatarColor.withValues(alpha: 0.15),
              child: Text(
                member.name[0],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: avatarColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              member.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            if (member.isCoreTeam)
              Chip(
                avatar: const Icon(
                  Icons.star,
                  size: 16,
                  color: GDGColors.green,
                ),
                label: const Text('Core Team'),
                backgroundColor: GDGColors.green.withValues(alpha: 0.1),
                side: BorderSide.none,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: GDGColors.blue),
        title: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: GDGColors.yellow, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Activity',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _activityItem(
              theme,
              'Joined the club',
              _formatDate(member.joinDate),
            ),
            _activityItem(theme, 'Assigned to ${member.section}', 'Ongoing'),
            _activityItem(theme, 'Activity data coming soon...', 'Placeholder'),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(ThemeData theme, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
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
