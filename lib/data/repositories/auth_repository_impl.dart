import '../../core/errors/app_exception.dart';
import '../../domain/models/member.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _ds;

  AuthRepositoryImpl(this._ds);

  @override
  Future<Member?> getCurrentUser() async {
    try {
      final raw = await _ds.getCurrentUserData();
      if (raw == null) return null;
      return Member.fromJson(raw);
    } catch (e) {
      throw AppException('Failed to get current user', cause: e);
    }
  }

  @override
  Future<Member> signInWithGoogle() async {
    try {
      final raw = await _ds.signInWithGoogle();
      return Member.fromJson(raw);
    } catch (e) {
      throw AppException('Sign-in failed', cause: e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _ds.signOut();
    } catch (e) {
      throw AppException('Sign-out failed', cause: e);
    }
  }

  @override
  Stream<Member?> get authStateChanges {
    return _ds.authStateChanges.map((raw) {
      if (raw == null) return null;
      return Member.fromJson(raw);
    });
  }
}
