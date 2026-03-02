import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/dummy_data.dart';
import '../services/gdg_event_service.dart';

/// EventsViewModel – Manages event data and loading state.
///
/// Responsibilities:
///   - Fetching events from GDG service (or fallback)
///   - Exposing filtered event lists (upcoming, active, archived)
///   - Loading indicator state
///
/// Views listen to changes via ListenableBuilder.
class EventsViewModel extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = true;

  // ── Getters ──
  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  /// Returns only non-archived events, sorted most recent first.
  List<Event> get activeEvents {
    return _events.where((e) => !e.isArchived).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Returns upcoming events (not Done), sorted by nearest date.
  List<Event> get upcomingEvents {
    return _events.where((e) => e.status != 'Done').toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Returns archived events (static placeholder).
  List<Event> get archivedEvents => DummyData.getArchivedEvents();

  // ── Data Loading ──

  /// Fetches events from the GDG service.
  /// Falls back to dummy data if the fetch fails.
  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await GDGEventService.fetchEvents();
    } catch (e) {
      // Network error — use fallback dummy data
      _events = DummyData.getFallbackEvents();
    }

    _isLoading = false;
    notifyListeners();
  }
}
