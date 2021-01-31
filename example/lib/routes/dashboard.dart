import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:example/pages/component/dashboard.dart';
import 'package:flutter/material.dart';

class DashboardRootRoute extends CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (context) => DashboardPage());
  }

  @override
  bool get doesStateMatch {
    return AppState.I.dashboard ?? false;
  }

  @override
  initState() {
    AppState.I.mutations.add(() {
      AppState.I.dashboard = true;
    });
  }

  @override
  removeState() {
    AppState.I.mutations.add(() {
      AppState.I.dashboard = false;
    });
  }
}
