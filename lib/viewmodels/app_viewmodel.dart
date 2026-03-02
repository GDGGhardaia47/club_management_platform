import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/dummy_data.dart';

/// AppViewModel – Manages global application state.
///
/// Responsibilities:
///   - Authentication state (login/logout)
///   - Theme mode (light/dark)
///   - Core Team simulation toggle
///   - Members list (from dummy data)
///
/// This is the top-level ViewModel shared across all views.
/// Views listen to changes via ListenableBuilder.
class AppViewModel extends ChangeNotifier {
  // ── Authentication ──
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  /// Mock login — sets session to active.
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Mock logout — clears session.
  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  // ── Theme Mode ──
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// Toggle between light and dark theme.
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // ── Core Team Simulation ──
  bool _isCoreTeam = true;
  bool get isCoreTeam => _isCoreTeam;

  /// Toggle core team mode (shows/hides admin features).
  void setCoreTeam(bool value) {
    _isCoreTeam = value;
    notifyListeners();
  }

  // ── Members ──
  /// Returns the list of active (non-archived) members.
  List<Member> get members => DummyData.getMembers();

  /// Returns archived members (static placeholder).
  List<Member> get archivedMembers => DummyData.getArchivedMembers();

  // ── Current User Info ──
  String get currentUserName => DummyData.currentUserName;
}
