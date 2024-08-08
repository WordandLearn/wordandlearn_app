import 'package:word_and_learn/controllers/services/writing/writing_interface.dart';
import 'package:word_and_learn/models/writing/models.dart';

class WritingControllerDatabase implements WritingInterface {
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
    //return null;
  }

  @override
  Future<Profile?> getChildProfile() async {
    return null;
  }

  Future<void> saveChildProfile(Profile? profile) async {}

  @override
  Future<ProfilePicture?> getProfilePicture() async {
    return null;
  }
}
