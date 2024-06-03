import 'package:word_and_learn/models/models.dart';

abstract class TeacherInterface {
  Future<Profile?> getTeacherProfile();

  Future<List<Class>> getTeacherClasses();

  Future<List<Profile>> getClassStudents(int classId);
}

abstract class TeacherDatabaseInterface implements TeacherInterface {
  Future<void> saveTeacherProfile(Profile profile);

  Future<void> saveTeacherClasses(List<Class> classes);

  Future<void> saveClassStudents(int classId, List<Profile> students);
}
