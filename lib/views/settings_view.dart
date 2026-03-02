import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../viewmodels/app_viewmodel.dart';

/// SettingsView – Theme toggle, core team simulation, about section.
///
/// MVVM Role: VIEW
/// - Reads state from [AppViewModel]
/// - Delegates all state changes to AppViewModel methods
/// - Pure UI — no local state management
class SettingsView extends StatelessWidget {
  final AppViewModel appViewModel;

  const SettingsView({super.key, required this.appViewModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Appearance ──
        _sectionHeader(theme, 'Appearance'),
        Card(
          child: SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              appViewModel.isDarkMode
                  ? 'Dark theme active'
                  : 'Light theme active',
            ),
            secondary: Icon(
              appViewModel.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: GDGColors.yellow,
            ),
            value: appViewModel.isDarkMode,
            // Delegate to ViewModel
            onChanged: (value) => appViewModel.setDarkMode(value),
          ),
        ),
        const SizedBox(height: 16),

        // ── Simulation ──
        _sectionHeader(theme, 'Simulation'),
        Card(
          child: SwitchListTile(
            title: const Text('Core Team Mode'),
            subtitle: const Text('Simulate being a Core Team member'),
            secondary: const Icon(
              Icons.admin_panel_settings,
              color: GDGColors.green,
            ),
            value: appViewModel.isCoreTeam,
            // Delegate to ViewModel
            onChanged: (value) => appViewModel.setCoreTeam(value),
          ),
        ),
        const SizedBox(height: 16),

        // ── About ──
        _sectionHeader(theme, 'About'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...([
                      GDGColors.blue,
                      GDGColors.red,
                      GDGColors.yellow,
                      GDGColors.green,
                    ]).map(
                      (c) => Container(
                        margin: const EdgeInsets.only(right: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GDG Ghardaïa',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Google Developer Groups (GDG) Ghardaïa is a local '
                  'community of developers who are interested in Google\'s '
                  'developer technology. We host events, workshops, and study '
                  'jams to help developers learn, connect, and grow.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'gdg.community.dev/gdg-ghardaia',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: GDGColors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Version ──
        Center(
          child: Text(
            'v0.1 · GDG Ghardaïa Club Management',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _sectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
