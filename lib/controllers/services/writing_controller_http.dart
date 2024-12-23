import 'dart:convert';

import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/writing/writing_interface.dart';
import 'package:word_and_learn/utils/http_client.dart';

import '../../models/writing/models.dart';
import 'package:http/http.dart' as http;

class WritingControllerHttp implements WritingInterface {
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

  Future<HttpResponse<Session>> getSessionFromCode(int sessionCode) async {
    http.Response res =
        await client.get("$sessionLessonsUrl/code/$sessionCode");
    HttpResponse<Session> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      Session session = Session.fromJson(json.decode(res.body));
      response.models = [session];
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

  Future<HttpResponse<Topic>> markTopicCompleted(Topic topic) async {
    http.Response res = await client.put(topicCompleteUrl(topic.id), {});

    HttpResponse<Topic> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      Topic topic = Topic.fromJson(json.decode(res.body));
      response.models = [topic];
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

  Future<HttpResponse<FlashcardText>> markFlashcardCompleted(
      FlashcardText flashcard) async {
    http.Response res =
        await client.put(flashcardCompletedUrl(flashcard.id), {});

    HttpResponse<FlashcardText> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      FlashcardText flashcard = FlashcardText.fromJson(json.decode(res.body));
      response.models = [flashcard];
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

  Future<HttpResponse<Example>> markExampleCompleted(Example example) async {
    http.Response res = await client.put(exampleCompletedUrl(example.id), {});

    HttpResponse<Example> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      Example example = Example.fromJson(json.decode(res.body));
      response.models = [example];
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

  Future<HttpResponse<Exercise>> markExerciseCompleted(
      Exercise exercise) async {
    http.Response res = await client.put(exerciseCompletedUrl(exercise.id), {});

    HttpResponse<Exercise> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      Exercise example = Exercise.fromJson(response.data);
      response.models = [example];
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
    http.Response res =
        await client.get(exerciseSubmissionAssessUrl(submissionId));

    HttpResponse<ExerciseResult> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      ExerciseResult result = ExerciseResult.fromJson(response.data);
      response.models = [result];
    }
    return response;
  }

  @override
  Future<Profile?> getChildProfile() async {
    http.Response res = await client.get(profileUrl);
    HttpResponse response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      Profile profile = Profile.fromJson(response.data['profile']);
      return profile;
    }
    return null;
  }

  @override
  Future<ProfilePicture?> getProfilePicture() async {
    http.Response res = await client.get(profilePictureUrl);
    HttpResponse<ProfilePicture> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      ProfilePicture? picture = ProfilePicture.fromJson(response.data);
      return picture;
    }
    return null;
  }
}
