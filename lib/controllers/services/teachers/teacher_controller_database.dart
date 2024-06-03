import 'package:word_and_learn/models/models.dart';

import 'teacher_interface.dart';

class TeacherControllerDatabase implements TeacherDatabaseInterface {
  @override
  Future<Profile?> getTeacherProfile() async {
    // Fetch teacher profile from database
    return null;
  }

  @override
  Future<void> saveTeacherProfile(Profile profile) async {
    // Save teacher profile to database
  }

  @override
  Future<List<Class>> getTeacherClasses() async {
    return <Class>[];
  }

  @override
  Future<void> saveTeacherClasses(List<Class> classes) async {
    // Save teacher classes to database
  }

  @override
  Future<List<Profile>> getClassStudents(int classId) async {
    return <Profile>[];
  }

  @override
  Future<void> saveClassStudents(int classId, List<Profile> students) async {
    // Save class students to database
  }
}
