import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:example/pages/component/not_found.dart';
import 'package:example/pages/component/opened_profile.dart';
import 'package:example/pages/component/profile.dart';
import 'package:example/pages/component/settings.dart';
import 'package:flutter/material.dart';

class OpenedProfileRoute extends CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (ctx) => OpenedProfilePage());
  }

  @override
  bool get doesStateMatch {
    return AppState.I.profileOpen != null;
  }

  @override
  initState() {
    print("opening profile from initstate");
  }

  @override
  void parseUriToState(Map<String, String> params) {
    AppState.I.mutations.add(() {
      AppState.I.profileOpen = params['profile'];
    });
  }

  @override
  removeState() {
    print("removing in profile route");
    AppState.I.mutations.add(() {
      AppState.I.profileOpen = null;
    });
  }

  @override
  Map<String, String> get variables => {"profile": AppState.I.profileOpen};
}

class ProfileRootRoute extends CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (context) => ProfilePage());
  }

  @override
  bool get doesStateMatch => AppState.I.selfProfile ?? false;

  @override
  initState() {}
}

class SettingsRootRoute extends CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (c) => SettingsPage());
  }

  @override
  bool get doesStateMatch => AppState.I.settings ?? false;

  @override
  initState() {}
}

class NotFoundRootRoute extends CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (ctx) => NotFoundPage());
  }

  @override
  bool get doesStateMatch => true;

  @override
  initState() {}
}
