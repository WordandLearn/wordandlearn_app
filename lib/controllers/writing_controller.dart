import 'package:get/get.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:http/http.dart' as http;

class WritingController extends GetxController {
  HttpClient client = HttpClient();
  Future<HttpResponse<Lesson>> getSessionLessons(int sessionID) async {
    http.Response res =
        await client.get("$sessionLessonsUrl/$sessionID/lessons");

    HttpResponse<Lesson> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Lesson> lessons = lessonFromJson(res.body);
      response.models = lessons;
    }

    return response;
  }

  Future<HttpResponse<Topic>> getLessonTopics(int lessonId) async {
    http.Response res = await client.get("$lessonTopicsUrl/$lessonId/topics");

    HttpResponse<Topic> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Topic> topics = topicFromJson(res.body);
      response.models = topics;
    }

    return response;
  }
}
