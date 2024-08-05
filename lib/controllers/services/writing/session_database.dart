import 'package:word_and_learn/controllers/services/interfaces/session_interfaces.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/models/exercise.dart';
import 'package:word_and_learn/models/flash_card_text.dart';
import 'package:word_and_learn/models/lesson.dart';
import 'package:word_and_learn/models/session.dart';
import 'package:word_and_learn/models/topic.dart';
import 'package:word_and_learn/objectbox.g.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';

class SessionDatabase implements SessionDatabaseInterface {
  @override
  Future<List<Topic>?> getLessonTopics(int lessonId) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Topic>();
    final query = box.query(Topic_.lesson.equals(lessonId)).build();
    final topics = query.find();
    return topics;
  }

  @override
  Future<Session?> getCurrentSession() async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<CurrentSession>();
    CurrentSession? currentSession = box.get(1);
    if (currentSession != null) {
      Session? session = currentSession.session.target;
      print("ABAB");
      print(session);
      return session;
    } else {
      return null;
    }
  }

  @override
  Future<List<Lesson>?> getSessionLessons(int sessionID) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Lesson>();
    final query = box.query(Lesson_.session.equals(sessionID)).build();
    final lessons = query.find();
    return lessons;
  }

  @override
  Future<List<Example>?> getTopicExamples(int topicId) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Example>();
    final query = box.query(Example_.topic.equals(topicId)).build();
    final examples = query.find();
    return examples;
  }

  @override
  Future<Exercise?> getTopicExercise(int topicId) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Exercise>();
    final query = box.query(Exercise_.topic.equals(topicId)).build();
    final exercise = query.findFirst();
    return exercise;
  }

  @override
  Future<List<FlashcardText>?> getTopicFlashcards(int topicId) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<FlashcardText>();
    final query = box.query(FlashcardText_.topic.equals(topicId)).build();
    final flashcards = query.find();
    return flashcards;
  }

  @override
  Future<Example?> markExampleCompleted(Example example) async {
    example.completed = true;
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Example>();
    box.put(example, mode: PutMode.update);
    return example;
  }

  @override
  Future<Exercise> markExerciseCompleted(Exercise exercise) async {
    exercise.completed = true;
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Exercise>();
    box.put(exercise, mode: PutMode.update);
    return exercise;
  }

  @override
  Future<FlashcardText?> markFlashcardCompleted(FlashcardText flashcard) async {
    flashcard.completed = true;
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<FlashcardText>();
    box.put(flashcard, mode: PutMode.update);
    return flashcard;
  }

  @override
  Future<Topic?> markTopicCompleted(Topic topic) async {
    topic.completed = true;
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Topic>();
    box.put(topic, mode: PutMode.update);
    return topic;
  }

  @override
  Future<void> saveCurrentSession(Session session) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final sessionbox = objectBox.store.box<Session>();
    sessionbox.put(session);

    final box = objectBox.store.box<CurrentSession>();
    CurrentSession currentSession =
        CurrentSession(dateOpened: DateTime.now(), id: 1);

    currentSession.session.target = session;
    box.put(currentSession, mode: PutMode.put);
  }

  @override
  Future<void> saveLessonTopics(List<Topic> topics) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Topic>();
    box.putMany(topics);
  }

  @override
  Future<void> saveSessionLessons(List<Lesson> lessons) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Lesson>();
    box.putMany(lessons);
  }

  @override
  Future<void> saveTopicExamples(List<Example> examples) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Example>();
    box.putMany(examples);
  }

  @override
  Future<void> saveTopicExercise(Exercise exercise) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<Exercise>();
    box.put(exercise);
  }

  @override
  Future<void> saveTopicFlashcards(List<FlashcardText> flashcards) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();

    final box = objectBox.store.box<FlashcardText>();
    box.putMany(flashcards);
  }
}
