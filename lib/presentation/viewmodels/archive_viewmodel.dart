import 'package:flutter/material.dart';
import '../../domain/models/member.dart';
import '../../domain/models/event.dart';
import '../../domain/repositories/member_repository.dart';
import '../../domain/repositories/event_repository.dart';

class ArchiveViewModel extends ChangeNotifier {
  final MemberRepository _memberRepo;
  final EventRepository _eventRepo;

  ArchiveViewModel(this._memberRepo, this._eventRepo);

  List<Member> _archivedMembers = [];
  List<Event> _archivedEvents = [];
  bool _isLoading = false;
  String? _error;

  List<Member> get archivedMembers => _archivedMembers;
  List<Event> get archivedEvents => _archivedEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadArchive() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _memberRepo.getArchivedMembers(),
        _eventRepo.getArchivedEvents(),
      ]);
      _archivedMembers = results[0] as List<Member>;
      _archivedEvents = results[1] as List<Event>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restoreMember(String id) async {
    try {
      await _memberRepo.restoreMember(id);
      _archivedMembers.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> restoreEvent(String id) async {
    try {
      await _eventRepo.restoreEvent(id);
      _archivedEvents.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
