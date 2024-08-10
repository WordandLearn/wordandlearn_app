import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/main.dart';
import 'package:word_and_learn/views/writing/settings/subscription_settings.dart';

class ResponseHandler {
  bool showedPaymentSnackBar = false;
  void _showSnackBar(text) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
          content: Row(
        children: [Text(text)],
      )));
    }
  }

  void handleUnauthorized() {
    // Handle unauthorized response
    _showSnackBar("You are not allowed to access this. Please Log In Again");
    // if (navigatorKey.currentContext != null) {
    //   final newRoute =
    //       MaterialPageRoute(builder: (context) => const LoginPage());
    //   predicate(Route<dynamic> route) {
    //     return route.isFirst;
    //   }

    //   Navigator.pushAndRemoveUntil(
    //       navigatorKey.currentContext!, newRoute, predicate);
    // }
  }

  void handlePaymentRequired() {
    // Handle payment required response
    if (!showedPaymentSnackBar) {
      _showSnackBar("You need to renew your subscription or start a trial");
      showedPaymentSnackBar = true;

      if (navigatorKey.currentContext != null) {
        //check if not on the subscriptionSetting already
        if (routeObserver.currentRoute != "SubscriptionSettings") {
          final newRoute = MaterialPageRoute(
              builder: (context) => const SubscriptionSettings(),
              settings: const RouteSettings(name: "SubscriptionSettings"));
          predicate(Route<dynamic> route) {
            return route.isFirst;
          }

          Navigator.pushAndRemoveUntil(
              navigatorKey.currentContext!, newRoute, predicate);
        }
      }
    }
  }

  void handleInternalServerError() {
    _showSnackBar("Ooops. An error has occured on our end.");
  }

  void handleBadRequest() {
    // Handle bad request response
  }

  void handleNotFound() {
    _showSnackBar("We could not find what you are looking for");
  }

  void handleSuccess() {
    // Handle success response
  }

  void checkResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        handleSuccess();
        break;
      case 400:
        handleBadRequest();
        break;
      case 401:
        handleUnauthorized();
        break;
      case 402:
        handlePaymentRequired();
        break;
      case 404:
        handleNotFound();
        break;
      case 500:
        handleInternalServerError();
        break;
    }
  }
}
