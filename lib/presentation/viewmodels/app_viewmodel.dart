import 'package:flutter/material.dart';
import '../../domain/models/member.dart';
import '../../domain/repositories/auth_repository.dart';

/// Manages global application state: authentication, theme, and role simulation.
class AppViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;

  AppViewModel(this._authRepo);

  // ── Auth ──
  Member? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  Member? get currentUser => _currentUser;

  /// Display name for the currently signed-in user (falls back to 'Guest').
  String get currentUserName => _currentUser?.name ?? 'Guest';

  Future<void> signIn() async {
    try {
      _currentUser = await _authRepo.signInWithGoogle();
      notifyListeners();
    } catch (e) {
      debugPrint('[AppViewModel] sign-in error: $e');
    }
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
    _currentUser = null;
    _isCoreTeam = false;
    notifyListeners();
  }

  // ── Theme ──
  bool _isDarkMode = true; // Dark mode is the default
  bool get isDarkMode => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // ── Role simulation (v0.1 — no real Firestore roles yet) ──
  // True when the signed-in user has the coreTeam role OR the dev toggle is on.
  bool _isCoreTeam = false;
  bool get isCoreTeam =>
      _isCoreTeam || _currentUser?.role == MemberRole.coreTeam;

  void setCoreTeam(bool value) {
    _isCoreTeam = value;
    notifyListeners();
  }
}
