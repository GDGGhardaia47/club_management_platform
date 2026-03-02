import 'package:flutter/material.dart';

/// EventDetailViewModel – Manages state for a single event's detail view.
///
/// Responsibilities:
///   - "Confirm as Organizer" toggle state
///
/// Each EventDetailView creates its own instance of this ViewModel.
class EventDetailViewModel extends ChangeNotifier {
  bool _isConfirmedOrganizer = false;

  bool get isConfirmedOrganizer => _isConfirmedOrganizer;

  /// Toggle the organizer confirmation state.
  void toggleOrganizer() {
    _isConfirmedOrganizer = !_isConfirmedOrganizer;
    notifyListeners();
  }
}
