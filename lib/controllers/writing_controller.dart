import 'package:get/get.dart';
import 'package:retry/retry.dart';
import 'package:word_and_learn/controllers/services/auth/user_profile_mixin.dart';
import 'package:word_and_learn/controllers/services/mixins/user_settings_http.dart';
import 'package:word_and_learn/controllers/services/writing/session_mixin.dart';
import 'package:word_and_learn/controllers/services/writing_controller_database.dart';
import 'package:word_and_learn/controllers/services/writing_controller_http.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/views/writing/upload/onboarding.dart';

class WritingController extends GetxController
    with UserSettingsMixin, UserProfileMixin, SessionMixin {
  RxList<Session> userSessions = <Session>[].obs;
  Rx<Session?> currentUserSession = Rxn<Session>();
  bool isRefreshing = false;

  WritingControllerHttp controllerHttp = WritingControllerHttp();
  WritingControllerDatabase controllerDatabase = WritingControllerDatabase();

  @override
  void onInit() {
    super.onInit();
    refetch();
  }

  void refetch() {
    if (isRefreshing == false) {
      isRefreshing = true;
      retry(
        () => _userSessions().then((value) {
          getCurrentSession();
        }),
        retryIf: (e) => e is HttpFetchException,
      );
    }
  }

  Future<void> _userSessions() async {
    HttpResponse<Session> response = await getUserSessions();

    if (response.isSuccess) {
      userSessions.value = response.models;
      if (response.models.isEmpty) {
        Get.snackbar(
            "Add a New Composition", "Add a new composition to start off");
        return Get.to(() => const UploadOnboardingPage(),
            routeName: "UploadOnboardingPage");
      }
      controllerDatabase.dbSetUserSessions(response.models);
    } else {
      throw HttpFetchException(
          "Could not get your lessons.", response.statusCode);
    }
  }

  Future setCurrentSession(Session session) async {
    await controllerDatabase.dbSetCurrentSession(session);
    currentUserSession.value = session;
    update();
  }

  Future<Session> getCurrentSession() async {
    Session? session = await controllerDatabase.dbGetCurrentLesson();
    if (session == null) {
      if (userSessions.isEmpty) {
        throw HttpFetchException("Could not get your lessons.", 404);
      } else {
        await setCurrentSession(userSessions.first);
        return userSessions.first;
      }
    } else {
      return session;
    }
  }

  Future<List<Lesson>> getCurrentSessionLessons() async {
    Session? session = currentUserSession.value!;
    // check if lessons are in db and return them
    // if not in db fetch from server and set in db before returning
    List<Lesson> sessionLessons =
        await controllerDatabase.dbGetSessionLessons(session);
    if (sessionLessons.isNotEmpty) {
      return sessionLessons;
    } else {
      List<Lesson>? lessons = await getSessionLessons(session.id);

      return lessons ?? [];
    }
  }
}
