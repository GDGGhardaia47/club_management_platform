// ignore_for_file: avoid_print

/// Raw data access for authentication.
/// In v0.1, uses a mock sign-in. Replace with Firebase Auth when connected.
class AuthRemoteDatasource {
  static const Map<String, dynamic> _mockUser = {
    'id': '1',
    'name': 'Abderrahmane SAOUDI',
    'email': 'abderrahmane@gdgghardaia.dz',
    'role': 'core_team',
    'departmentId': 'dept_dev',
    'sectionId': 'sec_mobile',
    'joinDate': '2024-09-01T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
  };

  bool _isSignedIn = false;

  /// Mock sign-in: always succeeds and returns the mock user.
  Future<Map<String, dynamic>> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _isSignedIn = true;
    print('[AuthRemoteDatasource] mock sign-in success');
    final now = DateTime.now().toIso8601String();
    return {
      ..._mockUser,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    print('[AuthRemoteDatasource] signed out');
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (!_isSignedIn) return null;
    final now = DateTime.now().toIso8601String();
    return {
      ..._mockUser,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  /// Stream that emits the current user data (or null) on auth state change.
  Stream<Map<String, dynamic>?> get authStateChanges async* {
    // TODO: replace with FirebaseAuth.instance.authStateChanges()
    //       combined with a Firestore member doc fetch.
    yield _isSignedIn
        ? {
            ..._mockUser,
            'createdAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          }
        : null;
  }
}
