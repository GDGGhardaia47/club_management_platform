import '../models/section.dart';

/// Abstract contract for section data operations.
abstract class SectionRepository {
  /// Returns all active sections for a given [departmentId].
  Future<List<Section>> getSectionsByDepartment(String departmentId);

  /// Returns a single section by [id].
  Future<Section> getSectionById(String id);

  /// Creates a new section document.
  Future<void> createSection(Section section);

  /// Updates an existing section document.
  Future<void> updateSection(Section section);

  /// Soft-deletes a section.
  Future<void> archiveSection(String id);
}
