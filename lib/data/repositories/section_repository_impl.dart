import '../../core/errors/app_exception.dart';
import '../../domain/models/section.dart';
import '../../domain/repositories/section_repository.dart';
import '../datasources/section_remote_datasource.dart';

class SectionRepositoryImpl implements SectionRepository {
  final SectionRemoteDatasource _ds;

  const SectionRepositoryImpl(this._ds);

  @override
  Future<List<Section>> getSectionsByDepartment(String departmentId) async {
    try {
      final raw = await _ds.fetchSectionsByDepartment(departmentId);
      return raw.map(Section.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load sections', cause: e);
    }
  }

  @override
  Future<Section> getSectionById(String id) async {
    try {
      final raw = await _ds.fetchSectionById(id);
      if (raw == null) throw AppException('Section not found: $id');
      return Section.fromJson(raw);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch section $id', cause: e);
    }
  }

  @override
  Future<void> createSection(Section section) async {
    try {
      await _ds.createSection(section.toJson());
    } catch (e) {
      throw AppException('Failed to create section', cause: e);
    }
  }

  @override
  Future<void> updateSection(Section section) async {
    try {
      await _ds.updateSection(section.id, section.toJson());
    } catch (e) {
      throw AppException('Failed to update section', cause: e);
    }
  }

  @override
  Future<void> archiveSection(String id) async {
    try {
      await _ds.archiveSection(id);
    } catch (e) {
      throw AppException('Failed to archive section', cause: e);
    }
  }
}
