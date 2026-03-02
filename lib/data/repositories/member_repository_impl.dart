import '../../core/errors/app_exception.dart';
import '../../domain/models/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_remote_datasource.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberRemoteDatasource _ds;

  const MemberRepositoryImpl(this._ds);

  @override
  Future<List<Member>> getActiveMembers() async {
    try {
      final raw = await _ds.fetchActiveMembers();
      return raw.map(Member.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load members', cause: e);
    }
  }

  @override
  Future<Member> getMemberById(String id) async {
    try {
      final raw = await _ds.fetchMemberById(id);
      if (raw == null) throw AppException('Member not found: $id');
      return Member.fromJson(raw);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch member $id', cause: e);
    }
  }

  @override
  Future<void> createMember(Member member) async {
    try {
      await _ds.createMember(member.toJson());
    } catch (e) {
      throw AppException('Failed to create member', cause: e);
    }
  }

  @override
  Future<void> updateMember(Member member) async {
    try {
      await _ds.updateMember(member.id, member.toJson());
    } catch (e) {
      throw AppException('Failed to update member', cause: e);
    }
  }

  @override
  Future<void> archiveMember(String id) async {
    try {
      await _ds.archiveMember(id);
    } catch (e) {
      throw AppException('Failed to archive member', cause: e);
    }
  }

  @override
  Future<List<Member>> getArchivedMembers() async {
    try {
      final raw = await _ds.fetchArchivedMembers();
      return raw.map(Member.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load archived members', cause: e);
    }
  }

  @override
  Future<void> restoreMember(String id) async {
    try {
      await _ds.restoreMember(id);
    } catch (e) {
      throw AppException('Failed to restore member', cause: e);
    }
  }
}
