import 'package:flutter/material.dart';
import '../../domain/models/event.dart';
import '../../domain/repositories/event_repository.dart';

class EventsViewModel extends ChangeNotifier {
  final EventRepository _repo;

  EventsViewModel(this._repo);

  /// Exposes the repository so views can supply it to child ViewModels (e.g. EventDetailViewModel).
  EventRepository get repo => _repo;

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Event> get upcomingEvents => _events
      .where((e) => e.status == EventStatus.upcoming || e.status == EventStatus.ongoing)
      .toList()
    ..sort((a, b) => a.startDate.compareTo(b.startDate));

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _repo.getActiveEvents();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> archiveEvent(String id) async {
    try {
      await _repo.archiveEvent(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

