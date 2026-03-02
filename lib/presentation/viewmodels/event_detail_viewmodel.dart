import 'package:flutter/material.dart';
import '../../domain/models/event.dart';
import '../../domain/repositories/event_repository.dart';

class EventDetailViewModel extends ChangeNotifier {
  final EventRepository _repo;

  EventDetailViewModel(this._repo);

  Event? _event;
  bool _isLoading = false;
  String? _error;

  Event? get event => _event;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvent(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _event = await _repo.getEventById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
