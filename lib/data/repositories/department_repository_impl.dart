import '../../core/errors/app_exception.dart';
import '../../domain/models/department.dart';
import '../../domain/repositories/department_repository.dart';
import '../datasources/department_remote_datasource.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDatasource _ds;

  const DepartmentRepositoryImpl(this._ds);

  @override
  Future<List<Department>> getActiveDepartments() async {
    try {
      final raw = await _ds.fetchActiveDepartments();
      return raw.map(Department.fromJson).toList();
    } catch (e) {
      throw AppException('Failed to load departments', cause: e);
    }
  }

  @override
  Future<Department> getDepartmentById(String id) async {
    try {
      final raw = await _ds.fetchDepartmentById(id);
      if (raw == null) throw AppException('Department not found: $id');
      return Department.fromJson(raw);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to fetch department $id', cause: e);
    }
  }

  @override
  Future<void> createDepartment(Department department) async {
    try {
      await _ds.createDepartment(department.toJson());
    } catch (e) {
      throw AppException('Failed to create department', cause: e);
    }
  }

  @override
  Future<void> updateDepartment(Department department) async {
    try {
      await _ds.updateDepartment(department.id, department.toJson());
    } catch (e) {
      throw AppException('Failed to update department', cause: e);
    }
  }

  @override
  Future<void> archiveDepartment(String id) async {
    try {
      await _ds.archiveDepartment(id);
    } catch (e) {
      throw AppException('Failed to archive department', cause: e);
    }
  }
}
