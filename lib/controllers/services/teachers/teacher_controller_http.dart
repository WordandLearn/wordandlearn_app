import 'dart:io';

import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/utils/http_client.dart';

import 'teacher_interface.dart';

class TeacherControllerHttp implements TeacherInterface {
  HttpClient client = HttpClient();

  @override
  Future<Profile> getTeacherProfile() async {
    // Fetch teacher profile from http
    http.Response res = await client.get(profileUrl);
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      UserClass userClass = UserClass.fromJson(response.data);
      return userClass.profile;
    } else {
      throw "Could not fetch profile";
    }
  }

  @override
  Future<List<Class>> getTeacherClasses() async {
    // Fetch teacher classes from http
    http.Response res = await client.get(teacherClassesUrl);
    HttpResponse<Class> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      response.models = classFromJson(res.body);
      return response.models;
    } else {
      throw "Could not fetch classes";
    }
  }

  @override
  Future<List<Profile>> getClassStudents(int classId) async {
    // fetch the students in a class
    http.Response res = await client.get(classStudentsUrl(classId));
    HttpResponse<Profile> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return profileFromJson(res.body);
    } else {
      throw "Could not fetch students";
    }
  }

  Future<HttpResponse> uploadStudentCompositions(
      int studentId, List<File> files) async {
    // Upload student compositions
    Map<String, String> body = {"student_id": studentId.toString()};
    Map<String, File> images = {};
    for (int i = 0; i < files.length; i++) {
      images["image$i"] = files[i];
    }
    http.Response res = await client.uploadWithKeys(uploadCompositionsUrl,
        files: images, body: body);
    HttpResponse response = HttpResponse.fromResponse(res);
    if (!response.isSuccess) {
      throw "Could not upload compositions";
    } else {
      return response;
    }
  }
}
