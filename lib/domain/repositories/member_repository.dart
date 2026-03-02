import '../models/member.dart';

/// Abstract contract for member data operations.
/// Implemented by [MemberRepositoryImpl] in the data layer.
abstract class MemberRepository {
  /// Returns all active (non-archived) members.
  Future<List<Member>> getActiveMembers();

  /// Returns a single member by [id]. Throws [AppException] if not found.
  Future<Member> getMemberById(String id);

  /// Creates a new member document.
  Future<void> createMember(Member member);

  /// Updates an existing member document.
  Future<void> updateMember(Member member);

  /// Soft-deletes a member by setting archived = true.
  Future<void> archiveMember(String id);

  /// Returns all archived members.
  Future<List<Member>> getArchivedMembers();

  /// Restores an archived member to active status.
  Future<void> restoreMember(String id);
}
