import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/writing/session_database.dart';
import 'package:word_and_learn/models/writing/models.dart';
import "package:http/http.dart" as http;
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/utils/http_client.dart';

import '../interfaces/session_interfaces.dart';

mixin SessionMixin implements SessionInterface {
  final HttpClient client = HttpClient();
  final SessionDatabase sessionDatabase = SessionDatabase();

  @override
  Future<List<Session>> getUserSessions() async {
    try {
      http.Response res = await client.get(sessionLessonsUrl);
      HttpResponse<Session> response = HttpResponse<Session>.fromResponse(res);
      if (response.isSuccess) {
        List<Session> sessions = sessionFromJson(res.body);
        sessionDatabase.saveUserSessions(sessions);
        return sessions;
      } else {
        throw HttpFetchException(
            "Could not fetch sessions", response.statusCode);
      }
    } on SocketException {
      List<Session>? sessions = await sessionDatabase.getUserSessions();
      if (sessions == null || sessions.isEmpty) {
        throw HttpFetchException("No internet connection", 0);
      } else {
        return sessions;
      }
    }
  }

  @override
  Future<Session?> getCurrentSession() async {
    Session? session = await sessionDatabase.getCurrentSession();
    return session;
  }

  Future<void> saveCurrentSession(Session session) async {
    await sessionDatabase.saveCurrentSession(session);
  }

  @override
  Future<List<Lesson>?> getSessionLessons(int sessionID) async {
    List<Lesson>? lessons = await sessionDatabase.getSessionLessons(sessionID);
    if (lessons != null && lessons.isNotEmpty) {
      return lessons;
    }

    http.Response res =
        await client.get("$sessionLessonsUrl/$sessionID/lessons");

    HttpResponse<Lesson> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Lesson> lessons = lessonFromJson(res.body);
      sessionDatabase.saveSessionLessons(lessons);
      return lessons;
    } else {
      throw HttpFetchException("Could not fetch lessons", response.statusCode);
    }
  }

  @override
  Future<List<Topic>?> getLessonTopics(int lessonId) async {
    List<Topic>? topics = await sessionDatabase.getLessonTopics(lessonId);
    if (topics != null && topics.isNotEmpty) {
      return topics;
    }

    http.Response res = await client.get("$lessonTopicsUrl/$lessonId/topics");

    HttpResponse<Topic> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Topic> topics = topicFromJson(res.body);
      sessionDatabase.saveLessonTopics(topics);
      return topics;
    } else {
      throw HttpFetchException("Could not fetch topics", response.statusCode);
    }
  }

  @override
  Future<List<Example>?> getTopicExamples(int topicId) async {
    List<Example>? examples = await sessionDatabase.getTopicExamples(topicId);
    if (examples != null && examples.isNotEmpty) {
      return examples;
    }

    http.Response res = await client.get(topicExamplesUrl(topicId));

    HttpResponse<Example> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      List<Example> examples = exampleFromJson(res.body);
      sessionDatabase.saveTopicExamples(examples);
      return examples;
    } else {
      throw HttpFetchException("Could not fetch examples", response.statusCode);
    }
  }

  @override
  Future<Exercise?> getTopicExercise(int topicId) async {
    Exercise? exercise = await sessionDatabase.getTopicExercise(topicId);
    if (exercise != null) {
      return exercise;
    } else {
      http.Response res = await client.get(topicExerciseUrl(topicId));

      HttpResponse<Exercise> response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        Exercise exercise = Exercise.fromJson(response.data);
        sessionDatabase.saveTopicExercise(exercise);
        return exercise;
      } else {
        throw HttpFetchException(
            "Could not fetch exercise", response.statusCode);
      }
    }
  }

  @override
  Future<List<FlashcardText>?> getTopicFlashcards(int topicId) async {
    List<FlashcardText>? flashcards =
        await sessionDatabase.getTopicFlashcards(topicId);

    if (flashcards != null && flashcards.isNotEmpty) {
      return flashcards;
    } else {
      http.Response res = await client.get(topicFlashcardsUrl(topicId));
      HttpResponse<FlashcardText> response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        List<FlashcardText> flashcards = flashcardTextFromJson(res.body);
        sessionDatabase.saveTopicFlashcards(flashcards);
        return flashcards;
      } else {
        throw HttpFetchException(
            "Could not fetch flashcards", response.statusCode);
      }
    }
  }

  @override
  Future<Lesson?> markLessonCompleted(Lesson lesson) async {
    http.Response res = await client.put(lessonCompletedUrl(lesson.id), {});

    HttpResponse<Lesson> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      sessionDatabase.markLessonCompleted(lesson);
      lesson.isCompleted = true;
      return lesson;
    } else {
      throw HttpFetchException(
          "Could not mark lesson as completed", response.statusCode);
    }
  }

  @override
  Future<Example?> markExampleCompleted(Example example) async {
    http.Response res = await client.put(exampleCompletedUrl(example.id), {});

    HttpResponse<Example> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      sessionDatabase.markExampleCompleted(example);
      example.completed = true;
      return example;
    } else {
      throw HttpFetchException(
          "Could not mark example as completed", response.statusCode);
    }
  }

  Future<bool?> isLessonComplete(Exercise exercise) async {
    Topic? topic = await sessionDatabase.getTopicFromExercise(exercise);
    if (topic != null) {
      List<Topic>? otherTopics = await sessionDatabase.getPartnerTopics(topic);
      if (otherTopics != null) {
        for (Topic otherTopic in otherTopics) {
          if (!otherTopic.completed) {
            return false;
          }
        }
        return true;
      }
    }
    return null;
  }

  Future<Lesson?> getLessonFromExercise(Exercise exercise) async {
    Topic? topic = await sessionDatabase.getTopicFromExercise(exercise);
    if (topic != null) {
      return sessionDatabase.getLessonById(topic.lesson);
    }
    return null;
  }

  @override
  Future<Exercise> markExerciseCompleted(Exercise exercise) async {
    http.Response res = await client.put(exerciseCompletedUrl(exercise.id), {});
    HttpResponse<Exercise> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      sessionDatabase.markExerciseCompleted(exercise);
      exercise.completed = true;

      return exercise;
    } else {
      throw HttpFetchException(
          "Could not mark exercise as completed", response.statusCode);
    }
  }

  @override
  Future<FlashcardText?> markFlashcardCompleted(FlashcardText flashcard) async {
    http.Response res =
        await client.put(flashcardCompletedUrl(flashcard.id), {});
    HttpResponse<FlashcardText> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      sessionDatabase.markFlashcardCompleted(flashcard);
      flashcard.completed = true;
      return flashcard;
    } else {
      throw HttpFetchException(
          "Could not mark flashcard as completed", response.statusCode);
    }
  }

  @override
  Future<Topic?> markTopicCompleted(Topic topic) async {
    http.Response res = await client.put(topicCompleteUrl(topic.id), {});

    HttpResponse<Topic> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      sessionDatabase.markTopicCompleted(topic);
      topic.completed = true;
      return topic;
    } else {
      throw HttpFetchException(
          "Could not mark topic as completed", response.statusCode);
    }
  }

  Future<ExerciseSubmission?> uploadExercise(
      int exerciseId, List<File> images) async {
    http.Response res = await client.upload(exerciseUploadUrl(exerciseId),
        files: images, key: 'image');

    HttpResponse<ExerciseSubmission> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      ExerciseSubmission submission =
          ExerciseSubmission.fromJson(response.data);
      return submission;
    } else {
      throw HttpFetchException(
          "Could not upload exercise", response.statusCode);
    }
  }

  Future<ExerciseResult?> getExerciseResults(int submissionId) async {
    http.Response res =
        await client.get(exerciseSubmissionAssessUrl(submissionId));

    HttpResponse<ExerciseResult> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      return ExerciseResult.fromJson(response.data);
    } else {
      throw HttpFetchException(
          "Could not fetch exercise results", response.statusCode);
    }
  }

  Future<HttpResponse> uploadComposition(List<File> images) async {
    Map<String, File> imageMap = {};
    File image1 = images[0];
    imageMap['image1'] = image1;
    if (images.length > 1) {
      File? image2 = images[1];
      imageMap['image2'] = image2;
    }

    http.Response res = await client
        .uploadWithKeys(compositionUploadUrl, files: imageMap, body: {});
    HttpResponse response = HttpResponse.fromResponse(res);

    return response;
  }

  Future<HttpResponse<TaskProgress>> getTaskState(String taskId) async {
    http.Response res = await client.get("$writingUrl/task/$taskId/state");
    HttpResponse<TaskProgress> response = HttpResponse.fromResponse(res);
    if (response.isSuccess) {
      TaskProgress taskState = TaskProgress.fromJson(response.data);
      response.models = [taskState];
    }
    return response;
  }

  Future<File> storeAudioFile(String audioUrl, String path) async {
    File file = File(path);
    File tempFile = await client.downloadFile(audioUrl);
    file.writeAsBytesSync(tempFile.readAsBytesSync());

    return file;
  }

  Future<void> _createDirectory(String path) async {
    Directory dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  Future<File?> getFlashcardAudio(int flashcardId) async {
    final directory = await getApplicationDocumentsDirectory();
    String dirPath = "${directory.path}/audio/flashcards/";
    await _createDirectory(dirPath);

    String path = "$dirPath$flashcardId.mp3";
    if (File(path).existsSync()) {
      return File(path);
    } else {
      http.Response res = await client.get(flashcardAudioUrl(flashcardId));
      HttpResponse response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        File audioFile = await storeAudioFile(response.data["audio"], path);
        return audioFile;
      }
    }

    return null;
  }

  Future<File?> getExampleAudio(int exampleId) async {
    final directory = await getApplicationDocumentsDirectory();
    String dirPath = "${directory.path}/audio/examples/";
    await _createDirectory(dirPath);

    String path = "$dirPath$exampleId.mp3";
    if (File(path).existsSync()) {
      return File(path);
    } else {
      http.Response res = await client.get(exampleAudioUrl(exampleId));
      HttpResponse response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        File audioFile = await storeAudioFile(response.data["audio"], path);
        return audioFile;
      }
    }

    return null;
  }
}
