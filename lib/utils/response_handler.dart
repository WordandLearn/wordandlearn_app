import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/components/animation/tap_bounce.dart';
import 'package:word_and_learn/components/primary_icon_button.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/main.dart';
import 'package:word_and_learn/views/writing/lessons/components/session_error_dialog.dart';
import 'package:word_and_learn/views/writing/settings/subscription_settings.dart';

class ResponseHandler {
  bool showedPaymentSnackBar = false;
  bool paymentDialogShowing = false;
  DateTime? lastPaymentDialogTime;
  Duration paymentDialogInterval = const Duration(minutes: 5);
  void _showSnackBar(text) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
          content: Row(
        children: [Text(text)],
      )));
    }
  }

  void _showSubscriptionDialog() {
    if (navigatorKey.currentContext != null && !paymentDialogShowing) {
      lastPaymentDialogTime = DateTime.now();
      showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
              onPopInvoked: (invoked) {
                paymentDialogShowing = false;
              },
              child: SessionErrorDialog(
                title: "Subscription or Trial Required To Continue",
                reason:
                    "You need to renew your subscription or start a trial to continue using wordandlearn",
                action: Column(
                  children: [
                    TapBounce(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const SubscriptionSettings();
                            },
                          ));
                        },
                        child: const PrimaryIconButton(
                            text: "Go to Subscription Settings",
                            icon: Icon(
                              CupertinoIcons.chevron_right,
                              color: Colors.white,
                              size: 17,
                            ))),
                  ],
                ),
              ),
            );
          });
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
    if (routeObserver.currentRoute == "SubscriptionSettings") return;
    if (lastPaymentDialogTime != null &&
        DateTime.now().difference(lastPaymentDialogTime!) <
            paymentDialogInterval) {
      return;
    } else {
      _showSubscriptionDialog();
    }
  }

  void handleInternalServerError() {
    _showSnackBar("Ooops. An error has occured on our end.");
  }

  void handleBadRequest() {
    // Handle bad request response
  }

  void handleNotFound() {
    // _showSnackBar("?We could not find what you are looking for");
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

  static void showNoInternetError() {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text("Please Check Your internet connection"),
          backgroundColor: AppColors.redColor,
        ),
      );
    }
  }
}
