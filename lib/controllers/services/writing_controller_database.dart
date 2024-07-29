import 'package:word_and_learn/models/models.dart';

mixin WritingControllerDatabase {
  Future<Session?> dbGetCurrentLesson() async {
    return null;
  }

  Future<bool?> dbSetUserSessions(List<Session> sessions) async {
    return null;
  }

  Future dbSetCurrentSession(Session session) async {
    return session;
  }

  Future<List<Lesson>> dbGetSessionLessons(Session session) async {
    return [];
  }

  Future<bool?> dbSetSessionLessons(
      Session session, List<Lesson> lessons) async {
    return null;
  }

  Future<void> dbLogout() async {
    return null;
  }
}
