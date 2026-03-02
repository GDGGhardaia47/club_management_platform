// ignore_for_file: avoid_print

/// Raw data access for events.
/// In v0.1, returns dummy data. Replace with Firestore calls when Firebase is connected.
class EventRemoteDatasource {
  Future<List<Map<String, dynamic>>> fetchActiveEvents() async {
    print('[EventRemoteDatasource] using dummy data');
    return _dummyEvents.where((e) => e['archived'] == false).toList();
  }

  Future<Map<String, dynamic>?> fetchEventById(String id) async {
    return _dummyEvents.where((e) => e['id'] == id).firstOrNull;
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    print('[EventRemoteDatasource] createEvent (stub): $data');
  }

  Future<void> updateEvent(String id, Map<String, dynamic> data) async {
    print('[EventRemoteDatasource] updateEvent (stub): $id');
  }

  Future<void> archiveEvent(String id) async {
    print('[EventRemoteDatasource] archiveEvent (stub): $id');
  }

  Future<List<Map<String, dynamic>>> fetchArchivedEvents() async {
    return _dummyEvents.where((e) => e['archived'] == true).toList();
  }

  Future<void> restoreEvent(String id) async {
    print('[EventRemoteDatasource] restoreEvent (stub): $id');
  }
}

final _now = DateTime.now().toIso8601String();

final List<Map<String, dynamic>> _dummyEvents = [
  {
    'id': 'e1',
    'title': 'Flutter Forward Extended Ghardaia',
    'description': 'Join us for Flutter Forward Extended! Learn about the latest Flutter updates.',
    'startDate': '2026-03-15T09:00:00.000Z',
    'endDate': '2026-03-15T17:00:00.000Z',
    'status': 'upcoming',
    'archived': false,
    'archivedAt': null,
    'createdBy': '1',
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'e2',
    'title': 'AI Study Jam',
    'description': 'Explore the world of Artificial Intelligence with hands-on exercises.',
    'startDate': '2026-02-28T09:00:00.000Z',
    'endDate': '2026-02-28T17:00:00.000Z',
    'status': 'ongoing',
    'archived': false,
    'archivedAt': null,
    'createdBy': '2',
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'e3',
    'title': 'DevFest Ghardaia 2025',
    'description': 'The biggest community-led developer event of the year!',
    'startDate': '2025-11-20T09:00:00.000Z',
    'endDate': '2025-11-20T18:00:00.000Z',
    'status': 'completed',
    'archived': false,
    'archivedAt': null,
    'createdBy': '1',
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'e4',
    'title': 'Google I/O Extended Ghardaia',
    'description': 'Watch Google I/O together and discuss the latest announcements.',
    'startDate': '2026-06-10T09:00:00.000Z',
    'endDate': '2026-06-10T17:00:00.000Z',
    'status': 'upcoming',
    'archived': false,
    'archivedAt': null,
    'createdBy': '1',
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'ae1',
    'title': 'Cloud Study Jam 2024',
    'description': 'Cloud study jam session.',
    'startDate': '2024-05-10T09:00:00.000Z',
    'endDate': '2024-05-10T17:00:00.000Z',
    'status': 'archived',
    'archived': true,
    'archivedAt': '2024-06-01T00:00:00.000Z',
    'createdBy': '1',
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'ae2',
    'title': 'Android Workshop 2024',
    'description': 'Android development workshop.',
    'startDate': '2024-03-22T09:00:00.000Z',
    'endDate': '2024-03-22T17:00:00.000Z',
    'status': 'archived',
    'archived': true,
    'archivedAt': '2024-04-01T00:00:00.000Z',
    'createdBy': '2',
    'createdAt': _now,
    'updatedAt': _now,
  },
];
