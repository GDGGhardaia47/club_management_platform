// ignore_for_file: avoid_print

/// Raw data access for departments.
/// In v0.1, returns dummy data. Replace with Firestore calls when Firebase is connected.
class DepartmentRemoteDatasource {
  Future<List<Map<String, dynamic>>> fetchActiveDepartments() async {
    print('[DepartmentRemoteDatasource] using dummy data');
    return _dummyDepartments.where((d) => d['archived'] == false).toList();
  }

  Future<Map<String, dynamic>?> fetchDepartmentById(String id) async {
    return _dummyDepartments.where((d) => d['id'] == id).firstOrNull;
  }

  Future<void> createDepartment(Map<String, dynamic> data) async {
    print('[DepartmentRemoteDatasource] createDepartment (stub): $data');
  }

  Future<void> updateDepartment(String id, Map<String, dynamic> data) async {
    print('[DepartmentRemoteDatasource] updateDepartment (stub): $id');
  }

  Future<void> archiveDepartment(String id) async {
    print('[DepartmentRemoteDatasource] archiveDepartment (stub): $id');
  }
}

final _now = DateTime.now().toIso8601String();

final List<Map<String, dynamic>> _dummyDepartments = [
  {
    'id': 'dept_dev',
    'name': 'Development Department',
    'description': 'Mobile, Web, and AI development.',
    'archived': false,
    'archivedAt': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'dept_design',
    'name': 'Design Department',
    'description': 'UI/UX and graphic design.',
    'archived': false,
    'archivedAt': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'dept_hr',
    'name': 'HR Department',
    'description': 'Recruitment and community management.',
    'archived': false,
    'archivedAt': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
];
