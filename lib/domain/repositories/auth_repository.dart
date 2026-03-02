import '../models/member.dart';

/// Abstract contract for authentication operations.
abstract class AuthRepository {
  /// Returns the currently signed-in user's Member profile, or null if not signed in.
  Future<Member?> getCurrentUser();

  /// Signs in with Google. Returns the Member profile on success.
  Future<Member> signInWithGoogle();

  /// Signs out the current user.
  Future<void> signOut();

  /// Stream of auth state changes (null = signed out, Member = signed in).
  Stream<Member?> get authStateChanges;
}
