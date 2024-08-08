import 'package:get/get.dart';
import 'package:retry/retry.dart';
import 'package:word_and_learn/controllers/services/auth/user_profile_mixin.dart';
import 'package:word_and_learn/controllers/services/mixins/user_settings_http.dart';
import 'package:word_and_learn/controllers/services/payments/payment_mixin.dart';
import 'package:word_and_learn/controllers/services/writing/session_mixin.dart';
import 'package:word_and_learn/controllers/services/writing_controller_database.dart';
import 'package:word_and_learn/controllers/services/writing_controller_http.dart';
import 'package:word_and_learn/models/writing/models.dart';
import 'package:word_and_learn/objectbox.g.dart';
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/views/writing/upload/onboarding.dart';

class WritingController extends GetxController
    with UserSettingsMixin, UserProfileMixin, SessionMixin, PaymentMixin {
  RxList<Session> userSessions = <Session>[].obs;
  Rx<Session?> currentUserSession = Rxn<Session>();
  bool isRefreshing = false;
  late Store store;
  WritingControllerHttp controllerHttp = WritingControllerHttp();
  WritingControllerDatabase controllerDatabase = WritingControllerDatabase();

  @override
  void onInit() {
    refetch();
    super.onInit();
  }

  void refetch() {
    if (isRefreshing == false) {
      isRefreshing = true;
      retry(
        () async {
          await fetchUserSessions();
        },
        retryIf: (e) => e is HttpFetchException,
      );
    }
  }

  // Future<void> _userSessions() async {
  //   HttpResponse<Session> response = await getUserSessions();

  //   if (response.isSuccess) {
  //     userSessions.value = response.models;
  //     if (response.models.isEmpty) {
  //       Get.snackbar(
  //           "Add a New Composition", "Add a new composition to start off");
  //       return Get.to(() => const UploadOnboardingPage(),
  //           routeName: "UploadOnboardingPage");
  //     }
  //     controllerDatabase.dbSetUserSessions(response.models);
  //   } else {
  //     throw HttpFetchException(
  //         "Could not get your lessons.", response.statusCode);
  //   }
  // }

  Future<List<Session>> fetchUserSessions() async {
    List<Session> sessions = await retry<List<Session>>(
      () {
        return getUserSessions();
      },
      retryIf: (p0) => p0 is HttpFetchException,
    );
    if (sessions.isEmpty) {
      Get.snackbar(
          "Add a New Composition", "Add a new composition to start off");
      Get.to(() => const UploadOnboardingPage());
      return sessions;
    } else {
      await fetchCurrentSession();
    }
    userSessions.value = sessions;
    return sessions;
  }

  Future<Session?> fetchCurrentSession() async {
    try {
      Session? session = await getCurrentSession();
      if (session == null && userSessions.isNotEmpty) {
        saveCurrentSession(userSessions.first);

        session = userSessions.first;
      }

      currentUserSession.value = session;
      return session;
    } on UnsupportedError {
      if (userSessions.isNotEmpty) {
        saveCurrentSession(userSessions.first);
        currentUserSession.value = userSessions.first;
        return userSessions.first;
      }
    }
    return null;
  }

  Future<void> setCurrentSession(Session session) async {
    await saveCurrentSession(session);
    currentUserSession.value = session;
  }
}
