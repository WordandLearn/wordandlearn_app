import 'package:flutter/foundation.dart';
import 'package:word_and_learn/controllers/services/interfaces/session_interfaces.dart';
import 'package:word_and_learn/models/writing/example.dart';
import 'package:word_and_learn/models/writing/exercise.dart';
import 'package:word_and_learn/models/writing/flash_card_text.dart';
import 'package:word_and_learn/models/writing/lesson.dart';
import 'package:word_and_learn/models/writing/session.dart';
import 'package:word_and_learn/models/writing/topic.dart';
import 'package:word_and_learn/objectbox.g.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';

class SessionDatabase implements SessionDatabaseInterface {
  @override
  Future<Session?> getCurrentSession() async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<CurrentSession>();
      List<CurrentSession> currentSessions = box.getAll();
      if (currentSessions.isNotEmpty) {
        Session? session = currentSessions.first.session.target;
        return session;
      } else {
        return null;
      }
    }
    return null;
  }

  @override
  Future<List<Topic>?> getLessonTopics(int lessonId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Topic>();
      final query = box.query(Topic_.lesson.equals(lessonId)).build();
      final topics = query.find();
      return topics;
    }
    return null;
  }

  Future<Lesson?> getLessonById(int lessonId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Lesson>();
      final query = box.query(Lesson_.id.equals(lessonId)).build();
      final lesson = query.findFirst();
      return lesson;
    }
    return null;
  }

  Future<Topic?> getTopicById(int topicId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Topic>();
      final query = box.query(Topic_.id.equals(topicId)).build();
      final topic = query.findFirst();
      return topic;
    }
    return null;
  }

  Future<Topic?> getTopicFromExercise(Exercise exercise) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Topic>();
      final query = box.query(Topic_.id.equals(exercise.topic)).build();
      final topic = query.findFirst();
      return topic;
    }
    return null;
  }

  Future<List<Topic>?> getPartnerTopics(Topic topic) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Topic>();
      final query = box.query(Topic_.lesson.equals(topic.lesson)).build();
      final topics = query.find();
      return topics;
    }
    return null;
  }

  @override
  Future<List<Lesson>?> getSessionLessons(int sessionID) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Lesson>();
      final query = box.query(Lesson_.session.equals(sessionID)).build();
      final lessons = query.find();
      return lessons;
    }
    return null;
  }

  @override
  Future<List<Example>?> getTopicExamples(int topicId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Example>();
      final query = box.query(Example_.topic.equals(topicId)).build();
      final examples = query.find();
      return examples;
    }
    return null;
  }

  @override
  Future<Exercise?> getTopicExercise(int topicId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Exercise>();
      final query = box.query(Exercise_.topic.equals(topicId)).build();
      final exercise = query.findFirst();
      return exercise;
    }
    return null;
  }

  @override
  Future<List<FlashcardText>?> getTopicFlashcards(int topicId) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<FlashcardText>();
      final query = box.query(FlashcardText_.topic.equals(topicId)).build();
      final flashcards = query.find();
      return flashcards;
    }
    return null;
  }

  @override
  Future<Example?> markExampleCompleted(Example example) async {
    if (!kIsWeb) {
      example.completed = true;
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Example>();
      box.put(example, mode: PutMode.update);
      return example;
    }
    return null;
  }

  @override
  Future<Exercise?> markExerciseCompleted(Exercise exercise) async {
    if (!kIsWeb) {
      exercise.completed = true;
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Exercise>();
      box.put(exercise, mode: PutMode.update);
      Topic? topic = await getTopicById(exercise.topic);
      if (topic != null) {
        topic.exerciseCompleted = true;
        final topicBox = objectBox.store.box<Topic>();
        topicBox.put(topic, mode: PutMode.update);
      }
      return exercise;
    }
    return null;
  }

  @override
  Future<FlashcardText?> markFlashcardCompleted(FlashcardText flashcard) async {
    if (!kIsWeb) {
      flashcard.completed = true;
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<FlashcardText>();
      box.put(flashcard, mode: PutMode.update);
      return flashcard;
    }
    return null;
  }

  @override
  Future<Topic?> markTopicCompleted(Topic topic) async {
    if (!kIsWeb) {
      topic.completed = true;
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Topic>();
      box.put(topic, mode: PutMode.update);
      return topic;
    }
    return null;
  }

  @override
  Future<void> saveCurrentSession(Session session) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final sessionbox = objectBox.store.box<Session>();
      sessionbox.put(session);

      final box = objectBox.store.box<CurrentSession>();
      box.removeAll();
      CurrentSession currentSession =
          CurrentSession(dateOpened: DateTime.now(), id: 0);

      currentSession.session.target = session;
      box.put(currentSession, mode: PutMode.put);
    }
  }

  @override
  Future<void> saveLessonTopics(List<Topic> topics) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Topic>();
      box.putMany(topics);
    }
  }

  @override
  Future<void> saveSessionLessons(List<Lesson> lessons) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Lesson>();
      box.putMany(lessons);
    }
  }

  @override
  Future<void> saveTopicExamples(List<Example> examples) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Example>();
      box.putMany(examples);
    }
  }

  @override
  Future<void> saveTopicExercise(Exercise exercise) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<Exercise>();
      box.put(exercise);
    }
  }

  @override
  Future<void> saveTopicFlashcards(List<FlashcardText> flashcards) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();

      final box = objectBox.store.box<FlashcardText>();
      box.putMany(flashcards);
    }
  }

  @override
  Future<List<Session>?> getUserSessions() async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Session>();
      final sessions = box.getAll();
      return sessions;
    }
    return null;
  }

  @override
  Future<void> saveUserSessions(List<Session> sessions) async {
    if (!kIsWeb) {
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Session>();
      box.putMany(sessions);
    }
  }

  @override
  Future<Lesson?> markLessonCompleted(Lesson lesson) async {
    if (!kIsWeb) {
      lesson.isCompleted = true;
      final ObjectBox objectBox = await ObjectBox.getInstance();
      final box = objectBox.store.box<Lesson>();
      box.put(lesson, mode: PutMode.update);
      return lesson;
    }
    return null;
  }
}
