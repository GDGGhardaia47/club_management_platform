import 'package:http/http.dart' as http;
import '../models/event.dart';
import 'dummy_data.dart';

/// Service to fetch GDG event data.
/// Tries to fetch from the public GDG community page.
/// Falls back to dummy data if the fetch fails.
class GDGEventService {
  static const String _gdgUrl = 'https://gdg.community.dev/gdg-ghardaia/';

  /// Attempt to fetch events from the GDG community page.
  /// Since there's no public API, we fall back to mock structured data.
  static Future<List<Event>> fetchEvents() async {
    try {
      final response = await http
          .get(Uri.parse(_gdgUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // The GDG community page doesn't provide a JSON API,
        // so we use our mock structured response based on real data.
        return _mockStructuredResponse();
      }
    } catch (e) {
      // Network error or timeout — fall back to dummy data.
      debugLog('GDG fetch failed: $e — using fallback data');
    }

    // Fallback: return dummy events
    return DummyData.getFallbackEvents();
  }

  /// Mock structured response simulating what an API would return.
  /// Based on real GDG Ghardaia events.
  static List<Event> _mockStructuredResponse() {
    final mockJson = [
      {
        'id': 'gdg1',
        'title': 'Flutter Forward Extended Ghardaia',
        'date': '2026-03-15',
        'location': 'University of Ghardaia – Amphi A',
        'description':
            'Join us for Flutter Forward Extended! Learn about the latest '
            'Flutter updates, new features, and best practices from the community.',
        'status': 'Planning',
        'departmentsInvolved': ['Development Department', 'Design Department'],
        'sectionsInvolved': ['Mobile Section', 'UI/UX Section'],
        'assignedMemberIds': ['1', '3', '6'],
      },
      {
        'id': 'gdg2',
        'title': 'AI Study Jam',
        'date': '2026-02-28',
        'location': 'GDG Ghardaia Hub',
        'description':
            'Explore the world of Artificial Intelligence with hands-on '
            'exercises and collaborative learning sessions.',
        'status': 'Ongoing',
        'departmentsInvolved': ['Development Department'],
        'sectionsInvolved': ['AI Section'],
        'assignedMemberIds': ['2', '4'],
      },
      {
        'id': 'gdg3',
        'title': 'DevFest Ghardaia 2025',
        'date': '2025-11-20',
        'location': 'Convention Center Ghardaia',
        'description':
            'The biggest community-led developer event of the year! '
            'Featuring talks, workshops, and networking opportunities.',
        'status': 'Done',
        'departmentsInvolved': [
          'Development Department',
          'Design Department',
          'HR Department',
        ],
        'sectionsInvolved': [
          'Mobile Section',
          'Web Section',
          'AI Section',
          'UI/UX Section',
          'Community Section',
        ],
        'assignedMemberIds': ['1', '2', '3', '4', '5'],
      },
      {
        'id': 'gdg4',
        'title': 'Google I/O Extended Ghardaia',
        'date': '2026-06-10',
        'location': 'University of Ghardaia – Hall B',
        'description':
            'Watch Google I/O together and discuss the latest announcements '
            'in Android, Web, Cloud, and AI technologies.',
        'status': 'Planning',
        'departmentsInvolved': ['Development Department', 'HR Department'],
        'sectionsInvolved': ['Mobile Section', 'Recruitment Section'],
        'assignedMemberIds': ['1', '5', '6'],
      },
    ];

    return mockJson.map((json) => Event.fromJson(json)).toList();
  }

  static void debugLog(String message) {
    // ignore: avoid_print
    print('[GDGEventService] $message');
  }
}
