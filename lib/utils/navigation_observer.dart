import 'package:flutter/material.dart';

class MyRouteObserver extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    currentRoute = route.settings.name;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentRoute = previousRoute?.settings.name;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    currentRoute = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    currentRoute = newRoute?.settings.name;
  }
}
