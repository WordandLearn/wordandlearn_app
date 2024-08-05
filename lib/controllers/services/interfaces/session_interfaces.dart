import 'package:word_and_learn/models/models.dart';

abstract class SessionInterface {
  Future<List<Session>?> getUserSessions();
  Future<Session?> getCurrentSession();
  Future<List<Lesson>?> getSessionLessons(int sessionID);
  Future<List<Topic>?> getLessonTopics(int lessonId);
  Future<Topic?> markTopicCompleted(Topic topic);
  Future<List<FlashcardText>?> getTopicFlashcards(int topicId);
  Future<FlashcardText?> markFlashcardCompleted(FlashcardText flashcard);
  Future<List<Example>?> getTopicExamples(int topicId);
  Future<Example?> markExampleCompleted(Example example);
  Future<Exercise?> getTopicExercise(int topicId);
  Future<Exercise> markExerciseCompleted(Exercise exercise);
}

abstract class SessionDatabaseInterface implements SessionInterface {
  Future<void> saveUserSessions(List<Session> sessions);
  Future<void> saveSessionLessons(List<Lesson> lessons);
  Future<void> saveLessonTopics(List<Topic> topics);
  Future<void> saveTopicFlashcards(List<FlashcardText> flashcards);
  Future<void> saveTopicExamples(List<Example> examples);
  Future<void> saveTopicExercise(Exercise exercise);
  Future<void> saveCurrentSession(Session session);
}
