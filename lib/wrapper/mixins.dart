import 'dart:async';

import 'package:baguette/wrapper/wrapper.dart';
import 'package:flutter/cupertino.dart';

class CRouter extends RouterDelegate<CRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CRoute> {
  final navigatorKey;
  final CRoute route;
  final void Function(CRoute newCroute) onPop;
  List<Page> pages;

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
  Future<void> setNewRoutePath(configuration) {
    return null;
  }
}

class BaguetteMaterialRouter extends RouterDelegate<CRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CRoute> {

  final GlobalKey<NavigatorState> navKey = GlobalKey();

  CRoute currentRoute = CRoute.buildFromState();

  List<Page> pages;
  List<CRoute> savedHistoryState;

  BaguetteMaterialRouter.withListener(ChangeNotifier cn) {
    cn.addListener(() {
      currentRoute = CRoute.buildFromState();
      pages = currentRoute.filterForKey().toPages();
      notifyListeners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Navigator(
          pages: pages,
          onPopPage: (route, result) {
            if (route.isFirst) {
              return true;
            }
            if (!route.didPop(result)) {
              return false;
            }
            currentRoute.handleRedirect();
            currentRoute = CRoute.buildFromState();
            notifyListeners();
            currentRoute.lastByKey().handlePop();
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
    configuration.initState();
    this.currentRoute = configuration;
    pages = currentRoute.filterForKey().toPages();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => this.navKey;

}

class BaguetteRouteInformationParser extends RouteInformationParser<CRoute> {
  @override
  Future<CRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    return CRoute.loadStateFromUri(Uri.parse(routeInformation.location));
  }

  @override
  RouteInformation restoreRouteInformation(CRoute configuration) {
    return RouteInformation(
        location: configuration.uriBuilder.build().toString());
  }
}
