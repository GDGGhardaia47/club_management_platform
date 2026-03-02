import '../models/member.dart';
import '../models/event.dart';

/// Provides all dummy/mock data for the app.
/// Contains members, events, and organizational structure.
class DummyData {
  // ── Demo User ──
  static const String currentUserName = 'Abderrahmane SAOUDI';

  // ── Organizational Structure ──
  // Department → Sections mapping
  static const Map<String, List<String>> orgStructure = {
    'Development Department': ['Mobile Section', 'Web Section', 'AI Section'],
    'Design Department': ['UI/UX Section', 'Graphic Design Section'],
    'HR Department': ['Recruitment Section', 'Community Section'],
  };

  // ── Dummy Members (5–8) ──
  static List<Member> getMembers() {
    return [
      Member(
        id: '1',
        name: 'Abderrahmane SAOUDI',
        section: 'Mobile Section',
        department: 'Development Department',
        roleTitle: 'Core Team – Lead',
        joinDate: DateTime(2024, 9, 1),
        isCoreTeam: true,
      ),
      Member(
        id: '2',
        name: 'Youssef BENMOUSSA',
        section: 'AI Section',
        department: 'Development Department',
        roleTitle: 'Core Team – AI Lead',
        joinDate: DateTime(2024, 9, 15),
        isCoreTeam: true,
      ),
      Member(
        id: '3',
        name: 'Amina KHALED',
        section: 'UI/UX Section',
        department: 'Design Department',
        roleTitle: 'Member – Designer',
        joinDate: DateTime(2024, 10, 1),
      ),
      Member(
        id: '4',
        name: 'Mohamed TAHA',
        section: 'Web Section',
        department: 'Development Department',
        roleTitle: 'Member – Web Developer',
        joinDate: DateTime(2024, 10, 10),
      ),
      Member(
        id: '5',
        name: 'Sara BOUDIAF',
        section: 'Recruitment Section',
        department: 'HR Department',
        roleTitle: 'Core Team – HR',
        joinDate: DateTime(2024, 9, 5),
        isCoreTeam: true,
      ),
      Member(
        id: '6',
        name: 'Khaled ZERROUKI',
        section: 'Mobile Section',
        department: 'Development Department',
        roleTitle: 'Member – Flutter Dev',
        joinDate: DateTime(2025, 1, 12),
      ),
      Member(
        id: '7',
        name: 'Fatima ZAHRA',
        section: 'Graphic Design Section',
        department: 'Design Department',
        roleTitle: 'Member – Graphic Designer',
        joinDate: DateTime(2025, 2, 1),
      ),
    ];
  }

  // ── Archived Members (static placeholder) ──
  static List<Member> getArchivedMembers() {
    return [
      Member(
        id: 'a1',
        name: 'Ali BENALI',
        section: 'Web Section',
        department: 'Development Department',
        roleTitle: 'Former Member',
        joinDate: DateTime(2023, 6, 1),
        isArchived: true,
      ),
      Member(
        id: 'a2',
        name: 'Nour HAMDI',
        section: 'Community Section',
        department: 'HR Department',
        roleTitle: 'Former Member',
        joinDate: DateTime(2023, 8, 15),
        isArchived: true,
      ),
    ];
  }

  // ── Dummy Events (3–5) ──
  static List<Event> getEvents() {
    return [
      Event(
        id: 'e1',
        title: 'Flutter Forward Extended Ghardaia',
        date: DateTime(2026, 3, 15),
        location: 'University of Ghardaia – Amphi A',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
            'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
        status: 'Planning',
        departmentsInvolved: ['Development Department', 'Design Department'],
        sectionsInvolved: ['Mobile Section', 'UI/UX Section'],
        assignedMemberIds: ['1', '3', '6'],
      ),
      Event(
        id: 'e2',
        title: 'AI Study Jam',
        date: DateTime(2026, 2, 28),
        location: 'GDG Ghardaia Hub',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Duis aute irure dolor in reprehenderit in voluptate velit esse '
            'cillum dolore eu fugiat nulla pariatur.',
        status: 'Ongoing',
        departmentsInvolved: ['Development Department'],
        sectionsInvolved: ['AI Section'],
        assignedMemberIds: ['2', '4'],
      ),
      Event(
        id: 'e3',
        title: 'DevFest Ghardaia 2025',
        date: DateTime(2025, 11, 20),
        location: 'Convention Center Ghardaia',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Excepteur sint occaecat cupidatat non proident, sunt in culpa '
            'qui officia deserunt mollit anim id est laborum.',
        status: 'Done',
        departmentsInvolved: [
          'Development Department',
          'Design Department',
          'HR Department',
        ],
        sectionsInvolved: [
          'Mobile Section',
          'Web Section',
          'AI Section',
          'UI/UX Section',
          'Community Section',
        ],
        assignedMemberIds: ['1', '2', '3', '4', '5'],
      ),
      Event(
        id: 'e4',
        title: 'Google I/O Extended Ghardaia',
        date: DateTime(2026, 6, 10),
        location: 'University of Ghardaia – Hall B',
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit '
            'aut fugit, sed quia consequuntur magni dolores.',
        status: 'Planning',
        departmentsInvolved: ['Development Department', 'HR Department'],
        sectionsInvolved: ['Mobile Section', 'Recruitment Section'],
        assignedMemberIds: ['1', '5', '6'],
      ),
    ];
  }

  // ── Archived Events (static placeholder) ──
  static List<Event> getArchivedEvents() {
    return [
      Event(
        id: 'ae1',
        title: 'Cloud Study Jam 2024',
        date: DateTime(2024, 5, 10),
        location: 'Online',
        description: 'Lorem ipsum dolor sit amet, archived event placeholder.',
        status: 'Done',
        departmentsInvolved: ['Development Department'],
        sectionsInvolved: ['Web Section'],
        assignedMemberIds: [],
        isArchived: true,
      ),
      Event(
        id: 'ae2',
        title: 'Android Workshop 2024',
        date: DateTime(2024, 3, 22),
        location: 'GDG Ghardaia Hub',
        description: 'Lorem ipsum dolor sit amet, archived event placeholder.',
        status: 'Done',
        departmentsInvolved: ['Development Department'],
        sectionsInvolved: ['Mobile Section'],
        assignedMemberIds: [],
        isArchived: true,
      ),
    ];
  }

  /// Fallback dummy events when API fetch fails.
  static List<Event> getFallbackEvents() {
    return getEvents();
  }
}
