import 'dart:async';
import 'package:baguette/core/baguette.dart';
import 'package:baguette/core/composer.dart';
import 'package:flutter/cupertino.dart';

class CRouter extends RouterDelegate<Baguette>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Baguette> {
  final navigatorKey;
  final Baguette route;
  final void Function(Baguette? newCroute) onPop;
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

class BaguetteMaterialRouter extends RouterDelegate<Baguette>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Baguette> {
  final GlobalKey<NavigatorState> navKey = GlobalKey();
  final BaguetteComposer provider;

  Baguette currentRoute;
  final ValueKey desktopKey;
  late List<Page> pages;
  late List<Page> desktopPages;
  final List<Function(Baguette b)> callbacks = [];

  BaguetteMaterialRouter.withListener(
      ChangeNotifier cn, this.provider, this.desktopKey, this.currentRoute) {
    setPages();
    cn.addListener(() {
      currentRoute = provider.buildFromState();
      pages =
          currentRoute.filterForKey(provider.defaultValueKey)?.toPages() ?? [];
      desktopPages = currentRoute.filterForKey(desktopKey)?.toPages() ?? [];
      notifyListeners();
      runCallbacks();
    });
  }

  BaguetteMaterialRouter(this.provider, this.desktopKey, this.currentRoute);

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
              currentRoute = provider.buildFromState();
              notifyListeners();
              runCallbacks();
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
            Baguette.deepPrint(currentRoute);
            currentRoute.handlePop();
            currentRoute = this.provider.buildFromState();
            notifyListeners();
            runCallbacks();
            return true;
          },
        );
      },
    );
  }

  @override
  get currentConfiguration => this.currentRoute;

  @override
  Future<void> setNewRoutePath(Baguette configuration) async {
    print("setting config ${configuration}");
    this.currentRoute = configuration;
    this.currentRoute.initState();
    setPages();
    print(
        "pages ${this.pages} curr ${this.currentRoute.filterForKey(provider.defaultValueKey)}");
    notifyListeners();
    runCallbacks();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => this.navKey;

  runCallbacks() {
    var c = this.currentConfiguration;
    for (var f in this.callbacks) {
      if (c != null) {
        f(c);
      }
    }
  }

  registerCallBack(Function(Baguette b) bc) {
    this.callbacks.add(bc);
  }

  setPages([ValueKey? key]) {
    key ??= this.provider.defaultValueKey;
    this.pages =
        currentRoute.filterForKey(provider.defaultValueKey)?.toPages() ?? [];
    desktopPages = currentRoute.filterForKey(desktopKey)?.toPages() ?? [];
  }
}

class BaguetteRouteInformationParser extends RouteInformationParser<Baguette> {
  final BaguetteComposer provider;

  BaguetteRouteInformationParser(this.provider);

  @override
  Future<Baguette> parseRouteInformation(
      RouteInformation routeInformation) async {
    return provider.buildFromUri(Uri.parse(routeInformation.location!));
  }

  @override
  RouteInformation restoreRouteInformation(Baguette configuration) {
    return RouteInformation(
        location: configuration.uriBuilder.build().toString());
  }
}
