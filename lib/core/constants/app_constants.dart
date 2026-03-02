/// Shared constants used across the app.
class AppConstants {
  AppConstants._();

  // ── Firestore Collection Names ──
  static const String membersCollection     = 'members';
  static const String departmentsCollection = 'departments';
  static const String sectionsCollection    = 'sections';
  static const String eventsCollection      = 'events';

  // ── Route Paths ──
  static const String routeLogin        = '/login';
  static const String routeHome         = '/home';
  static const String routeMembers      = '/members';
  static const String routeMemberDetail = '/members/:id';
  static const String routeMemberNew    = '/members/new';
  static const String routeEvents       = '/events';
  static const String routeEventDetail  = '/events/:id';
  static const String routeEventNew     = '/events/new';
  static const String routeArchive      = '/archive';
  static const String routeSettings     = '/settings';
}
