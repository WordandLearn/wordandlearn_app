import 'dart:developer';

import 'package:get/get.dart';
import 'package:word_and_learn/controllers/services/writing_controller_database.dart';
import 'package:word_and_learn/controllers/services/writing_controller_http.dart';
import 'package:word_and_learn/models/models.dart';

class WritingController extends GetxController
    with WritingControllerHttp, WritingControllerDatabase {
  RxList<Session> userSessions = <Session>[].obs;
  Rx<Session?> currentUserSession = Rxn<Session>();
  bool isRefreshing = false;
  @override
  void onInit() {
    super.onInit();
    refetch();
  }

  void refetch() {
    if (isRefreshing == false) {
      isRefreshing = true;
      _userSessions().then((value) {
        getCurrentSession();
      }).whenComplete(() {
        isRefreshing = false;
      });
    }
  }

  Future<void> _userSessions() async {
    HttpResponse<Session> response = await getUserSessions();

    if (response.isSuccess) {
      userSessions.value = response.models;
      dbSetUserSessions(response.models);
    }
  }

  Future setCurrentSession(Session session) async {
    await dbSetCurrentSession(session);
    currentUserSession.value = session;
    update();
  }

  Future<Session> getCurrentSession() async {
    Session? session = await dbGetCurrentLesson();
    if (session == null) {
      if (userSessions.isEmpty) {
        throw "Lessons are not available at the moment. Please try again later.";
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
    List<Lesson> sessionLessons = await dbGetSessionLessons(session);
    if (sessionLessons.isNotEmpty) {
      return sessionLessons;
    } else {
      HttpResponse<Lesson> response = await getSessionLessons(session.id);

      if (response.isSuccess) {
        List<Lesson> lessons = response.models;
        dbSetSessionLessons(session, lessons);
        return lessons;
      }
      return [];
    }
  }

  // Future<Session?> get currentSession async {
  //   //attempt getting current session from db
  //   Session? session = await dbGetCurrentLesson();
  //   if (session == null) {
  //     if (userSessions.isEmpty) {
  //       //get session from network and set first as the current lesson

  //       HttpResponse<Session> response = await getUserSessions();

  //       if (response.isSuccess) {
  //         userSessions.value = response.models;
  //         dbSetUserSessions(response.models);
  //         dbSetCurrentSession(userSessions.first);
  //         session = userSessions.first;
  //       } else {
  //         return null;
  //       }
  //     } else {
  //       //set first session as current session
  //       dbSetCurrentSession(userSessions.first);
  //       userSessions.first;
  //     }
  //   }
  //   return session;
  // }
}
