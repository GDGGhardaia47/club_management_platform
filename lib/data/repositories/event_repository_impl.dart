import '../../core/errors/app_exception.dart';
import '../../domain/models/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource _ds;

  const EventRepositoryImpl(this._ds);

  @override
  Future<List<Event>> getActiveEvents() async {
    try {
      final raw = await _ds.fetchActiveEvents();
      return raw.map(Event.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load events', cause: e);
    }
  }

  @override
  Future<Event> getEventById(String id) async {
    try {
      final raw = await _ds.fetchEventById(id);
      if (raw == null) throw AppException('Event not found: $id');
      return Event.fromJson(raw);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch event $id', cause: e);
    }
  }

  @override
  Future<void> createEvent(Event event) async {
    try {
      await _ds.createEvent(event.toJson());
    } catch (e) {
      throw AppException('Failed to create event', cause: e);
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    try {
      await _ds.updateEvent(event.id, event.toJson());
    } catch (e) {
      throw AppException('Failed to update event', cause: e);
    }
  }

  @override
  Future<void> archiveEvent(String id) async {
    try {
      await _ds.archiveEvent(id);
    } catch (e) {
      throw AppException('Failed to archive event', cause: e);
    }
  }

  @override
  Future<List<Event>> getArchivedEvents() async {
    try {
      final raw = await _ds.fetchArchivedEvents();
      return raw.map(Event.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load archived events', cause: e);
    }
  }

  @override
  Future<void> restoreEvent(String id) async {
    try {
      await _ds.restoreEvent(id);
    } catch (e) {
      throw AppException('Failed to restore event', cause: e);
    }
  }
}
