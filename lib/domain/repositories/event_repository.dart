import '../models/event.dart';

/// Abstract contract for event data operations.
abstract class EventRepository {
  /// Returns all active (non-archived) events.
  Future<List<Event>> getActiveEvents();

  /// Returns a single event by [id].
  Future<Event> getEventById(String id);

  /// Creates a new event document.
  Future<void> createEvent(Event event);

  /// Updates an existing event document.
  Future<void> updateEvent(Event event);

  /// Soft-deletes an event by setting archived = true.
  Future<void> archiveEvent(String id);

  /// Returns all archived events.
  Future<List<Event>> getArchivedEvents();

  /// Restores an archived event.
  Future<void> restoreEvent(String id);
}
