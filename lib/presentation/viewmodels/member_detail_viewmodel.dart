import 'package:flutter/material.dart';
import '../../domain/models/member.dart';
import '../../domain/repositories/member_repository.dart';

class MemberDetailViewModel extends ChangeNotifier {
  final MemberRepository _repo;

  MemberDetailViewModel(this._repo);

  Member? _member;
  bool _isLoading = false;
  String? _error;

  Member? get member => _member;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMember(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _member = await _repo.getMemberById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
