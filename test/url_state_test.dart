import 'package:baguette/core/baguette.dart';
import 'package:baguette/core/composer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baguette/baguette.dart';
import 'package:uri/uri.dart';

import 'routes.dart';

void main() {
  test("export and rehydrate normal url", () {});

  test("export and rehydrate url with parameters", () {
    var stateProvider = TestState(isCats: true);
    var routes = [
      Baguette(UriTemplate("/"), RootRoute(stateProvider), [
        Baguette(UriTemplate("cats"), CatRoute(stateProvider), [
          Baguette(UriTemplate("{catname}"), NamedCatRoute(stateProvider), [])
        ])
      ])
    ];
    var notFound =
        Baguette(UriTemplate("/notfound"), RootRoute(stateProvider), []);
    var provider = DefaultCRouteProvider(routes, notFound);
    var newCRoute = provider.buildFromState();
    print(newCRoute.uriBuilder.build().toString());
    // print(CRoute.deepPrint(newCRoute));
    var anotherRoute = provider.buildFromUri(Uri.parse("/cats/sirmeow"));
    print(anotherRoute.uriBuilder.build().toString());
    var anotherReplaceRoute = provider.buildFromUri(Uri.parse("/cats"));
    print(Baguette.deepPrint(anotherRoute));
    expect("", "");
  });

  test("export and rehydrate with multiple query parameters and uri templates",
      () {
    // var routes = [
    //   CRoute(UriTemplate("/"), RootRoute(),
    //       [CRoute(UriTemplate("/cats"), CatRoute(), [])])
    // ];
    // var provider = DefaultCRouteProvider();
    // provider.addState<TestState>(() => TestState(isRoot: true, isCats: true));
    // provider.setRoutes(routes);
    // var newCRoute = CRoute.buildFromState(provider);
    // print(newCRoute.uriBuilder.build().toString());
  });

  test("fuzz easy", () {
    // var routes = [
    //   CRoute(UriTemplate("/"), RootRoute(),
    //       [CRoute(UriTemplate("/cats"), CatRoute(), [])])
    // ];
    // var provider = DefaultCRouteProvider();
    // provider.addState<TestState>(() => TestState(isRoot: true, isCats: true));
    // provider.setRoutes(routes);
    // var newCRoute = CRoute.buildFromState(provider);
    // print(newCRoute.uriBuilder.build().toString());
  });
}
