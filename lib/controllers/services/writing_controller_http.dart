import 'dart:convert';
import 'dart:io';

import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/utils/http_client.dart';

import '../../models/models.dart';
import 'package:http/http.dart' as http;

mixin WritingControllerHttp {
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

  Future<HttpResponse<FlashcardText>> getTopicFlashcards(int topicId) async {
    http.Response res = await client.get(topicFlashcardsUrl(topicId));

    HttpResponse<FlashcardText> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<FlashcardText> flashcards = flashcardTextFromJson(res.body);
      response.models = flashcards;
    }

    return response;
  }

  Future<HttpResponse<Example>> getTopicExamples(int topicId) async {
    http.Response res = await client.get(topicExamplesUrl(topicId));

    HttpResponse<Example> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Example> examples = exampleFromJson(res.body);
      response.models = examples;
    }

    return response;
  }

  Future<HttpResponse<Exercise>> getTopicExercise(int topicId) async {
    http.Response res = await client.get(topicExerciseUrl(topicId));

    HttpResponse<Exercise> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Exercise> exercises = [Exercise.fromJson(json.decode(res.body))];
      response.models = exercises;
    }

    return response;
  }

  Future<HttpResponse<ExerciseSubmission>> uploadExercise(
      int exerciseId, List<File> images) async {
    http.Response res = await client.upload(exerciseUploadUrl(exerciseId),
        files: images, key: 'image');

    HttpResponse<ExerciseSubmission> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      ExerciseSubmission submission =
          ExerciseSubmission.fromJson(json.decode(res.body));
      response.models = [submission];
    }

    return response;
  }

  Future<HttpResponse<Session>> getUserSessions() async {
    http.Response res = await client.get(sessionLessonsUrl);
    HttpResponse<Session> response = HttpResponse<Session>.fromResponse(res);
    if (response.isSuccess) {
      List<Session> sessions = sessionFromJson(res.body);
      response.models = sessions;
    }
    return response;
  }

  Future getExerciseSubmission(int submissionId) async {
    http.Response res =
        await client.get(exerciseSubmissionDetailUrl(submissionId));

    HttpResponse<ExerciseSubmission> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      ExerciseSubmission submission =
          ExerciseSubmission.fromJson(json.decode(res.body));
      response.models = [submission];
    }

    return response;
  }

  Future<HttpResponse<ExerciseResult>> getExerciseResults(
      int submissionId) async {
    // http.Response res =
    //     await client.get(exerciseSubmissionAssessUrl(submissionId));

    // HttpResponse<ExerciseResult> response = HttpResponse.fromResponse(res);
    // if (response.isSuccess) {
    //   ExerciseResult result = ExerciseResult();
    //   response.models = [result];
    // }

    ExerciseResult exerciseResult = ExerciseResult(
        id: 1,
        improvement: true,
        score: 4,
        feedback:
            "That was great you were able to create a really good description of your scence. Felt very real",
        recommendation: "Use more proverbs and idioms in your sentence",
        exercise: 20);

    return HttpResponse(message: "good", statusCode: 200, data: "")
      ..models = [exerciseResult];
  }
}
