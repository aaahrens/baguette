import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uri/uri.dart';

void main() {
  var state = AppStateBloc();
  GetIt.I.registerSingleton<AppStateBloc>(state);

  var animalCRoute = CRoute(
      UriTemplate("{animal_name}{?animal_color,animal_type}"),
      AnimalRoute(), []);

  List<CRoute> routes = [
    CRoute(UriTemplate("/settings"), SettingsRootRoute(), []),
    CRoute(UriTemplate("/"), DashboardRootRoute(), [
      CRoute(UriTemplate("cats"), CatTab(), [animalCRoute]),
      CRoute(UriTemplate("dogs"), DogTab(), [animalCRoute]),
      CRoute(UriTemplate("turtles"), TurtleTab(), [animalCRoute])
    ]),
  ];

  var notFound = CRoute(UriTemplate("/404"), NotFoundRootRoute(), []);
  var provider = DefaultCRouteProvider(routes, notFound);
  var router =
      BaguetteMaterialRouter.withListener(state, provider, ValueKey("desktop"));
  GetIt.I.registerSingleton<CRouteProviderBase>(provider);
  GetIt.I.registerSingleton<BaguetteMaterialRouter>(router);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final provider = GetIt.I.get<CRouteProviderBase>();
  final router = GetIt.I.get<BaguetteMaterialRouter>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router,
      routeInformationParser: BaguetteRouteInformationParser(provider),
    );
  }
}
