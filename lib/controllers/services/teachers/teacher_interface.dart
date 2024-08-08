import 'package:word_and_learn/models/writing/models.dart';

abstract class TeacherInterface {
  Future<Profile?> getTeacherProfile();

  Future<List<Class_>> getTeacherClasses();

  Future<List<Profile>> getClassStudents(int classId);
}

abstract class TeacherDatabaseInterface implements TeacherInterface {
  Future<void> saveTeacherProfile(Profile profile);

  Future<void> saveTeacherClasses(List<Class_> classes);

  Future<void> saveClassStudents(int classId, List<Profile> students);
}
