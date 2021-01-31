import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:example/bloc/croute.dart';
import 'package:example/routes.dart';
import 'package:example/routes/dashboard.dart';
import 'package:example/routes/opened_profile.dart';
import 'package:flutter/material.dart';
import 'package:uri/uri.dart';

BaguetteMaterialRouter bRouter;

void main() {
  CRouteProvider.instance.routes = [
    CRoute(UriTemplate("/profile"), ProfileRootRoute(), []),
    CRoute(UriTemplate("/settings"), SettingsRootRoute(), []),
    CRoute(UriTemplate("/dashboard"), DashboardRootRoute(), [
      CRoute(UriTemplate("{profile}"), OpenedProfileRoute(), [
        CRoute(UriTemplate("cats"), CatTab(), []),
        CRoute(UriTemplate("dogs"), DogTab(), []),
        CRoute(UriTemplate("turtles"), TurtleTab(), [])
      ])
    ]),
  ];

  CRouteProvider.instance.notFound =
      CRoute(UriTemplate("404"), NotFoundRootRoute(), []);

  AppState.I.dashboard = true;
  AppState.I.currentTab.listen((event) {
    print("added tab ${event}");
  });

  CRouteProvider.doOnInit = [
    () {
      AppState.I.finalizeChanges();
    }
  ];

  CRouteProvider.doOnRemove = [
    () {
      AppState.I.finalizeChanges();
    }
  ];

  bRouter = BaguetteMaterialRouter.withListener(AppState.I);
  CRouteConversion.I.addCurrentCRouteToStream();
  bRouter.addListener(() {
    CRouteConversion.I.addCurrentCRouteToStream();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: bRouter,
      routeInformationParser: BaguetteRouteInformationParser(),
    );
  }
}
