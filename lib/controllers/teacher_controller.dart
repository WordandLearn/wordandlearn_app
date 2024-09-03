import 'package:cross_file/cross_file.dart';
import 'package:get/get.dart';
import 'package:word_and_learn/controllers/services/teachers/teacher_controller_database.dart';
import 'package:word_and_learn/controllers/services/teachers/teacher_controller_http.dart';
import 'package:word_and_learn/models/writing/models.dart';

class TeacherController extends GetxController {
  Rx<Profile?> profile = Rx<Profile?>(null);
  RxList<Class_> classes = <Class_>[].obs;
  Map<int, List<XFile>> compositionImages = {};

  TeacherControllerDatabase controllerDatabase = TeacherControllerDatabase();
  TeacherControllerHttp controllerHttp = TeacherControllerHttp();
  @override
  void onInit() {
    getProfile();
    getClasses();
    super.onInit();
  }

  Future<Profile?> getProfile() async {
    // Gets the profile of the logged in user.
    Profile? profile_ = await controllerDatabase.getTeacherProfile();
    if (profile_ == null) {
      profile_ = await controllerHttp.getTeacherProfile();
      await controllerDatabase.saveTeacherProfile(profile_!);
    }
    profile.value = profile_;
    return profile_;
  }

  Future<List<Class_>> getClasses() async {
    // Gets the classes of the logged in user.
    List<Class_> classes_ = await controllerDatabase.getTeacherClasses();
    if (classes_.isEmpty) {
      classes_ = await controllerHttp.getTeacherClasses();
      await controllerDatabase.saveTeacherClasses(classes);
    }
    classes.value = classes_;
    return classes;
  }

  Future<List<Profile>> getClassStudents(int classId) async {
    // Gets the students in a class.
    List<Profile> students = await controllerDatabase.getClassStudents(classId);
    if (students.isEmpty) {
      students = await controllerHttp.getClassStudents(classId);
      await controllerDatabase.saveClassStudents(classId, students);
    }
    return students;
  }

  Future<HttpResponse> uploadCompositions(
      int studentId, List<XFile> images) async {
    HttpResponse response =
        await controllerHttp.uploadStudentCompositions(studentId, images);
    return response;
  }
}
