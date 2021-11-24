import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/keys.dart';
import 'package:example/pages/not_found.dart';
import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:uri/uri.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() {
  configureApp();
  var state = AppStateBloc();

  var animalCRoute = Baguette(
      UriTemplate("{animal_name}{?animal_color,animal_type}"),
      () => AnimalRoute(state), []);

  List<Baguette> routes = [
    Baguette(UriTemplate("/settings"), () => SettingsRootRoute(state), []),
    Baguette(UriTemplate("/"), () => DashboardRootRoute(state), [
      Baguette(UriTemplate("cats"), () => CatTab(state), [animalCRoute]),
      Baguette(UriTemplate("dogs"), () => DogTab(state), [animalCRoute]),
      Baguette(UriTemplate("turtles"), () => TurtleTab(state), [animalCRoute])
    ]),
  ];

  state.currentRoute = routes.last;

  var notFound =
      Baguette(UriTemplate("/404"), () => NotFoundRootRoute(state), []);
  var provider = DefaultCRouteProvider(routes, notFound, TopLevelKey);

  var router = BaguetteMaterialRouter.withListener(
      state, provider, DeskTopKey, routes.last);

  router.registerCallBack((c) {
    state.currentRoute = c;
  });

  runApp(MyApp(
    provider: provider,
    router: router,
  ));
}

class MyApp extends StatelessWidget {
  final BaguetteComposer provider;
  final BaguetteMaterialRouter router;

  const MyApp({Key? key, required this.provider, required this.router})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp.router(
        routerDelegate: router,
        routeInformationParser: BaguetteRouteInformationParser(provider),
      ),
    );
  }
}
