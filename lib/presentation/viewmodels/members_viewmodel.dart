import 'package:flutter/material.dart';
import '../../domain/models/member.dart';
import '../../domain/repositories/member_repository.dart';

class MembersViewModel extends ChangeNotifier {
  final MemberRepository _repo;

  MembersViewModel(this._repo);

  List<Member> _members = [];
  bool _isLoading = false;
  String? _error;

  List<Member> get members => _members;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMembers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _members = await _repo.getActiveMembers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> archiveMember(String id) async {
    try {
      await _repo.archiveMember(id);
      _members.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
