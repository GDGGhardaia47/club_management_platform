import '../models/department.dart';

/// Abstract contract for department data operations.
abstract class DepartmentRepository {
  /// Returns all active departments.
  Future<List<Department>> getActiveDepartments();

  /// Returns a single department by [id].
  Future<Department> getDepartmentById(String id);

  /// Creates a new department document.
  Future<void> createDepartment(Department department);

  /// Updates an existing department document.
  Future<void> updateDepartment(Department department);

  /// Soft-deletes a department.
  Future<void> archiveDepartment(String id);
}
