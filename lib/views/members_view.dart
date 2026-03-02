import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/member.dart';
import 'member_detail_view.dart';

/// MembersView – Displays members grouped by Department → Section.
///
/// MVVM Role: VIEW
/// - Receives members list and isCoreTeam flag from parent
/// - Delegates navigation to MemberDetailView on tap
/// - Shows FAB for core team members (mock add action)
class MembersView extends StatelessWidget {
  final List<Member> members;
  final bool isCoreTeam;

  const MembersView({
    super.key,
    required this.members,
    required this.isCoreTeam,
  });

  @override
  Widget build(BuildContext context) {
    // Group members by department (excluding archived)
    final Map<String, List<Member>> grouped = {};
    for (final member in members.where((m) => !m.isArchived)) {
      grouped.putIfAbsent(member.department, () => []).add(member);
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          return _buildDepartmentSection(context, entry.key, entry.value);
        }).toList(),
      ),
      // FAB visible only for core team members
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

  /// Builds a department section with its sections and members.
  Widget _buildDepartmentSection(
    BuildContext context,
    String department,
    List<Member> deptMembers,
  ) {
    final theme = Theme.of(context);

    // Sub-group by section within department
    final Map<String, List<Member>> sectionGroups = {};
    for (final m in deptMembers) {
      sectionGroups.putIfAbsent(m.section, () => []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Department header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.business, color: GDGColors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                department,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: GDGColors.blue,
                ),
              ),
            ],
          ),
        ),
        // Sections within department
        ...sectionGroups.entries.map((sectionEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.folder_outlined,
                      color: GDGColors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      sectionEntry.key,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: GDGColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              // Member tiles
              ...sectionEntry.value.map((member) {
                return _MemberTile(member: member, isCoreTeam: isCoreTeam);
              }),
            ],
          );
        }),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

/// Single member list tile — tapping navigates to MemberDetailView.
class _MemberTile extends StatelessWidget {
  final Member member;
  final bool isCoreTeam;

  const _MemberTile({required this.member, required this.isCoreTeam});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor.withValues(alpha: 0.15),
          child: Text(
            member.name[0],
            style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          member.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(member.roleTitle, style: theme.textTheme.bodySmall),
        trailing: member.isCoreTeam
            ? Chip(
                label: const Text('Core', style: TextStyle(fontSize: 11)),
                backgroundColor: GDGColors.green.withValues(alpha: 0.15),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )
            : null,
        // Navigate to Member Detail View
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  MemberDetailView(member: member, isCoreTeam: isCoreTeam),
            ),
          );
        },
      ),
    );
  }
}
