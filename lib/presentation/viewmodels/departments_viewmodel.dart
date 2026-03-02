import 'package:flutter/material.dart';
import '../../domain/models/department.dart';
import '../../domain/models/section.dart';
import '../../domain/repositories/department_repository.dart';
import '../../domain/repositories/section_repository.dart';

class DepartmentsViewModel extends ChangeNotifier {
  final DepartmentRepository _deptRepo;
  final SectionRepository _sectionRepo;

  DepartmentsViewModel(this._deptRepo, this._sectionRepo);

  List<Department> _departments = [];
  Map<String, List<Section>> _sectionsByDept = {};
  bool _isLoading = false;
  String? _error;

  List<Department> get departments => _departments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Section> sectionsFor(String departmentId) =>
      _sectionsByDept[departmentId] ?? [];

  Future<void> loadDepartments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _departments = await _deptRepo.getActiveDepartments();
      // Load sections for each department
      final results = await Future.wait(
        _departments.map((d) => _sectionRepo.getSectionsByDepartment(d.id)),
      );
      _sectionsByDept = {
        for (var i = 0; i < _departments.length; i++)
          _departments[i].id: results[i],
      };
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
