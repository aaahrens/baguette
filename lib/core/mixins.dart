import 'dart:async';
import 'package:baguette/core/croute.dart';
import 'package:baguette/core/provider.dart';
import 'package:flutter/cupertino.dart';

class CRouter extends RouterDelegate<CRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CRoute> {
  final navigatorKey;
  final CRoute route;
  final void Function(CRoute newCroute) onPop;
  late List<Page> pages;

  CRouter(this.navigatorKey, this.route, this.onPop) {
    this.pages = this.route.toPages();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: this.pages,
      onPopPage: (route, result) {
        if (route.isFirst || !route.didPop(result)) {
          return false;
        }
        this.onPop(this.route.handlePop());
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}

class BaguetteMaterialRouter extends RouterDelegate<CRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CRoute> {
  final GlobalKey<NavigatorState> navKey = GlobalKey();
  final CRouteProviderBase provider;

  late CRoute currentRoute;

  final ValueKey desktopKey;
  late List<Page> pages;
  late List<Page> desktopPages;

  BaguetteMaterialRouter.withListener(
      ChangeNotifier cn, this.provider, this.desktopKey) {
    cn.addListener(() {
      print("inside listener");
      currentRoute = provider.buildFromState();
      print("route returned");
      CRoute.deepPrint(currentRoute);
      pages =
          currentRoute.filterForKey(provider.defaultValueKey)?.toPages() ?? [];
      desktopPages = currentRoute.filterForKey(desktopKey)?.toPages() ?? [];
      notifyListeners();
    });
  }

  BaguetteMaterialRouter(this.provider, this.desktopKey);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 700) {
          return Navigator(
            pages: desktopPages,
            onPopPage: (route, result) {
              if (route.isFirst) {
                return true;
              }
              if (!route.didPop(result)) {
                return false;
              }
              print("calling pop");
              currentRoute.handlePop();
              currentRoute.handleRedirect();
              currentRoute = provider.buildFromState();
              notifyListeners();
              return true;
            },
          );
        }
        return Navigator(
          pages: pages,
          onPopPage: (route, result) {
            if (route.isFirst) {
              return true;
            }
            if (!route.didPop(result)) {
              return false;
            }
            print("calling pop");
            CRoute.deepPrint(currentRoute);
            currentRoute.handlePop();
            currentRoute.handleRedirect();
            currentRoute = this.provider.buildFromState();
            notifyListeners();
            return true;
          },
        );
      },
    );
  }

  @override
  get currentConfiguration => this.currentRoute;

  @override
  Future<void> setNewRoutePath(CRoute configuration) async {
    this.currentRoute = configuration;
    this.currentRoute.initState();
    this.pages =
        currentRoute.filterForKey(provider.defaultValueKey)?.toPages() ?? [];

    desktopPages = currentRoute.filterForKey(desktopKey)?.toPages() ?? [];
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => this.navKey;
}

class BaguetteRouteInformationParser extends RouteInformationParser<CRoute> {
  final CRouteProviderBase provider;

  BaguetteRouteInformationParser(this.provider);

  @override
  Future<CRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    var ret = provider.buildFromUri(Uri.parse(routeInformation.location!));
    print("hello in parse route information");
    CRoute.deepPrint(ret);
    return ret;
  }

  @override
  RouteInformation restoreRouteInformation(CRoute configuration) {
    return RouteInformation(
        location: configuration.uriBuilder.build().toString());
  }
}
