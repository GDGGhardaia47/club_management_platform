// ignore_for_file: avoid_print

/// Raw data access for sections.
/// In v0.1, returns dummy data. Replace with Firestore calls when Firebase is connected.
class SectionRemoteDatasource {
  Future<List<Map<String, dynamic>>> fetchSectionsByDepartment(String departmentId) async {
    print('[SectionRemoteDatasource] using dummy data for department: $departmentId');
    return _dummySections.where((s) => s['departmentId'] == departmentId && s['archived'] == false).toList();
  }

  Future<Map<String, dynamic>?> fetchSectionById(String id) async {
    return _dummySections.where((s) => s['id'] == id).firstOrNull;
  }

  Future<void> createSection(Map<String, dynamic> data) async {
    print('[SectionRemoteDatasource] createSection (stub): $data');
  }

  Future<void> updateSection(String id, Map<String, dynamic> data) async {
    print('[SectionRemoteDatasource] updateSection (stub): $id');
  }

  Future<void> archiveSection(String id) async {
    print('[SectionRemoteDatasource] archiveSection (stub): $id');
  }
}

final _now = DateTime.now().toIso8601String();

final List<Map<String, dynamic>> _dummySections = [
  {'id': 'sec_mobile',      'name': 'Mobile Section',         'departmentId': 'dept_dev',    'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_web',         'name': 'Web Section',            'departmentId': 'dept_dev',    'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_ai',          'name': 'AI Section',             'departmentId': 'dept_dev',    'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_uiux',        'name': 'UI/UX Section',          'departmentId': 'dept_design', 'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_graphic',     'name': 'Graphic Design Section', 'departmentId': 'dept_design', 'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_recruitment', 'name': 'Recruitment Section',    'departmentId': 'dept_hr',     'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
  {'id': 'sec_community',   'name': 'Community Section',      'departmentId': 'dept_hr',     'archived': false, 'archivedAt': null, 'createdAt': _now, 'updatedAt': _now},
];
