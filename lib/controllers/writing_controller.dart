import 'package:get/get.dart';
import 'package:word_and_learn/controllers/services/auth/user_profile_mixin.dart';
import 'package:word_and_learn/controllers/services/mixins/user_settings_http.dart';
import 'package:word_and_learn/controllers/services/payments/payment_mixin.dart';
import 'package:word_and_learn/controllers/services/writing/session_mixin.dart';
import 'package:word_and_learn/controllers/services/writing_controller_database.dart';
import 'package:word_and_learn/controllers/services/writing_controller_http.dart';
import 'package:word_and_learn/models/writing/models.dart';

class WritingController extends GetxController
    with UserSettingsMixin, UserProfileMixin, SessionMixin, PaymentMixin {
  RxList<Session> userSessions = <Session>[].obs;
  Rx<Session?> currentUserSession = Rxn<Session>();
  bool isRefreshing = false;
  WritingControllerHttp controllerHttp = WritingControllerHttp();
  WritingControllerDatabase controllerDatabase = WritingControllerDatabase();

  @override
  void onInit() {
    getUserSubscriptionStatus();
    Future.delayed(const Duration(seconds: 1), () {
      refetch();
    });

    super.onInit();
  }

  void refetch() {
    getUserSessions().then(
      (value) {
        if (value != null) {
          userSessions.value = value;
        }
        fetchCurrentSession();
      },
    );
  }

  // Future<List<Session>?> fetchUserSessions({bool navigate = true}) async {
  //   List<Session>? sessions = await retry<List<Session>>(
  //     () {
  //       return getUserSessions();
  //     },
  //     retryIf: (p0) => p0 is HttpFetchException,
  //   );
  //   if (sessions.isEmpty) {
  //     if (navigate) {
  //       Get.snackbar(
  //           "Add a New Composition", "Add a new composition to start off");
  //       Get.to(() => const UploadOnboardingPage());
  //     }
  //     return sessions;
  //   } else {
  //     await fetchCurrentSession();
  //   }
  //   userSessions.value = sessions;
  //   return sessions;
  // }

  Future<Session?> fetchCurrentSession() async {
    if (currentUserSession.value != null) {
      return currentUserSession.value;
    }
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
    currentUserSession.value = session;
    currentUserSession.refresh();
    await saveCurrentSession(session);
  }
}
