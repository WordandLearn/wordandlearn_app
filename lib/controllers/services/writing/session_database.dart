import 'package:word_and_learn/controllers/services/interfaces/session_interfaces.dart';
import 'package:word_and_learn/models/example.dart';
import 'package:word_and_learn/models/exercise.dart';
import 'package:word_and_learn/models/flash_card_text.dart';
import 'package:word_and_learn/models/lesson.dart';
import 'package:word_and_learn/models/topic.dart';

class SessionDatabase implements SessionDatabaseInterface {
  @override
  Future<List<Topic>?> getLessonTopics(int lessonId) async {
    return null;
  }

  @override
  Future<List<Lesson>?> getSessionLessons(int sessionID) async {
    return null;
  }

  @override
  Future<List<Example>?> getTopicExamples(int topicId) async {
    return null;
  }

  @override
  Future<Exercise?> getTopicExercise(int topicId) async {
    return null;
  }

  @override
  Future<List<FlashcardText>?> getTopicFlashcards(int topicId) async {
    return null;
  }

  @override
  Future<Example?> markExampleCompleted(Example example) async {
    example.completed = true;
    return example;
  }

  @override
  Future<Exercise> markExerciseCompleted(Exercise exercise) async {
    exercise.completed = true;
    return exercise;
  }

  @override
  Future<FlashcardText?> markFlashcardCompleted(FlashcardText flashcard) async {
    flashcard.completed = true;
    return flashcard;
  }

  @override
  Future<Topic?> markTopicCompleted(Topic topic) async {
    topic.completed = true;
    return topic;
  }

  @override
  Future<void> saveLessonTopics(List<Topic> topics) async {}

  @override
  Future<void> saveSessionLessons(List<Lesson> lessons) async {}

  @override
  Future<void> saveTopicExamples(List<Example> examples) async {}

  @override
  Future<void> saveTopicExercise(Exercise exercise) async {}

  @override
  Future<void> saveTopicFlashcards(List<FlashcardText> flashcards) async {}
}
