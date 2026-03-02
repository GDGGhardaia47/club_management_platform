// ignore_for_file: avoid_print


/// Raw data access for members.
/// In v0.1, returns dummy data. Replace with Firestore calls when Firebase is connected.
///
/// When integrating Firebase:
///   import 'package:cloud_firestore/cloud_firestore.dart';
///   final _db = FirebaseFirestore.instance;
///   Replace the dummy return with real Firestore queries.
class MemberRemoteDatasource {
  Future<List<Map<String, dynamic>>> fetchActiveMembers() async {
    // TODO: replace with Firestore query
    // final snap = await _db.collection('members').where('archived', isEqualTo: false).get();
    // return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    print('[MemberRemoteDatasource] using dummy data');
    return _dummyMembers.where((m) => m['archived'] == false).toList();
  }

  Future<Map<String, dynamic>?> fetchMemberById(String id) async {
    // TODO: replace with Firestore doc fetch
    return _dummyMembers.where((m) => m['id'] == id).firstOrNull;
  }

  Future<void> createMember(Map<String, dynamic> data) async {
    // TODO: await _db.collection('members').add(data);
    print('[MemberRemoteDatasource] createMember (stub): $data');
  }

  Future<void> updateMember(String id, Map<String, dynamic> data) async {
    // TODO: await _db.collection('members').doc(id).update(data);
    print('[MemberRemoteDatasource] updateMember (stub): $id');
  }

  Future<void> archiveMember(String id) async {
    // TODO: await _db.collection('members').doc(id).update({'archived': true, 'archivedAt': ...});
    print('[MemberRemoteDatasource] archiveMember (stub): $id');
  }

  Future<List<Map<String, dynamic>>> fetchArchivedMembers() async {
    return _dummyMembers.where((m) => m['archived'] == true).toList();
  }

  Future<void> restoreMember(String id) async {
    print('[MemberRemoteDatasource] restoreMember (stub): $id');
  }
}

// ── Dummy data ──────────────────────────────────────────────────────────────
final _now = DateTime.now().toIso8601String();

final List<Map<String, dynamic>> _dummyMembers = [
  {
    'id': '1',
    'name': 'Abderrahmane SAOUDI',
    'email': 'abderrahmane@gdgghardaia.dz',
    'role': 'core_team',
    'departmentId': 'dept_dev',
    'sectionId': 'sec_mobile',
    'joinDate': '2024-09-01T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': '2',
    'name': 'Youssef BENMOUSSA',
    'email': 'youssef@gdgghardaia.dz',
    'role': 'core_team',
    'departmentId': 'dept_dev',
    'sectionId': 'sec_ai',
    'joinDate': '2024-09-15T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': '3',
    'name': 'Amina KHALED',
    'email': 'amina@gdgghardaia.dz',
    'role': 'member',
    'departmentId': 'dept_design',
    'sectionId': 'sec_uiux',
    'joinDate': '2024-10-01T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': '4',
    'name': 'Mohamed TAHA',
    'email': 'mohamed.taha@gdgghardaia.dz',
    'role': 'member',
    'departmentId': 'dept_dev',
    'sectionId': 'sec_web',
    'joinDate': '2024-10-10T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': '5',
    'name': 'Sara BOUDIAF',
    'email': 'sara@gdgghardaia.dz',
    'role': 'core_team',
    'departmentId': 'dept_hr',
    'sectionId': 'sec_recruitment',
    'joinDate': '2024-09-05T00:00:00.000Z',
    'status': 'active',
    'archived': false,
    'archivedAt': null,
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
  {
    'id': 'a1',
    'name': 'Ali BENALI',
    'email': 'ali.benali@gdgghardaia.dz',
    'role': 'member',
    'departmentId': 'dept_dev',
    'sectionId': 'sec_web',
    'joinDate': '2023-06-01T00:00:00.000Z',
    'status': 'archived',
    'archived': true,
    'archivedAt': '2024-08-01T00:00:00.000Z',
    'profilePictureUrl': null,
    'createdAt': _now,
    'updatedAt': _now,
  },
];
