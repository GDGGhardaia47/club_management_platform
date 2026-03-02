import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/member.dart';
import '../viewmodels/app_viewmodel.dart';
import '../viewmodels/members_viewmodel.dart';
import 'member_detail_view.dart';

/// MembersView – Displays active members grouped by department.
///
/// Clean Architecture: VIEW — reads from [MembersViewModel] and [AppViewModel]
/// via Provider; no direct repo/service access.
class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MembersViewModel>().loadMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MembersViewModel>();
    final isCoreTeam = context.watch<AppViewModel>().isCoreTeam;

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text('Error: ${vm.error}'));
    }

    // Group active members by departmentId.
    final Map<String, List<Member>> grouped = {};
    for (final member in vm.members.where((m) => !m.archived)) {
      grouped.putIfAbsent(member.departmentId, () => []).add(member);
    }

    return Scaffold(
      body: grouped.isEmpty
          ? const Center(child: Text('No members found.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                return _buildDepartmentSection(
                    context, entry.key, entry.value, isCoreTeam);
              }).toList(),
            ),
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

  Widget _buildDepartmentSection(
    BuildContext context,
    String departmentId,
    List<Member> deptMembers,
    bool isCoreTeam,
  ) {
    final theme = Theme.of(context);

    // Sub-group by sectionId within department.
    final Map<String, List<Member>> sectionGroups = {};
    for (final m in deptMembers) {
      final key = m.sectionId ?? 'No Section';
      sectionGroups.putIfAbsent(key, () => []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.business, color: GDGColors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                departmentId,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: GDGColors.blue,
                ),
              ),
            ],
          ),
        ),
        ...sectionGroups.entries.map((sectionEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ...sectionEntry.value.map(
                (member) => _MemberTile(member: member, isCoreTeam: isCoreTeam),
              ),
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

    // Avatar colour derived from departmentId (placeholder logic for v0.1).
    Color avatarColor;
    if (member.departmentId.toLowerCase().contains('dev')) {
      avatarColor = GDGColors.blue;
    } else if (member.departmentId.toLowerCase().contains('design')) {
      avatarColor = GDGColors.red;
    } else {
      avatarColor = GDGColors.yellow;
    }

    final isMemberCoreTeam = member.role == MemberRole.coreTeam;
    final roleLabel = isMemberCoreTeam ? 'Core Team' : 'Member';

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
        subtitle: Text(roleLabel, style: theme.textTheme.bodySmall),
        trailing: isMemberCoreTeam
            ? Chip(
                label: const Text('Core', style: TextStyle(fontSize: 11)),
                backgroundColor: GDGColors.green.withValues(alpha: 0.15),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              )
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MemberDetailView(
                member: member,
                isCoreTeam: isCoreTeam,
              ),
            ),
          );
        },
      ),
    );
  }
}
