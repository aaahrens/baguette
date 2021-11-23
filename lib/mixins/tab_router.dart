import 'dart:async';

import 'package:baguette/baguette.dart';
import 'package:baguette/core/baguette.dart';
import 'package:flutter/material.dart';

mixin CRouteListenerForKey<T extends StatefulWidget> on State<T> {

  ValueKey get filterKey;

  Widget get loadingScreen;

  late GlobalKey<NavigatorState> navigatorKey;

  late Baguette currentCRoute;

  late StreamSubscription _sub;

  void Function(Baguette newCroute) get onPop;

  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
    _sub.cancel();
    Future.delayed(Duration.zero, _listenToRouteChanges);
  }

  _listenToRouteChanges() {

  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate:
          CRouter(this.navigatorKey, this.currentCRoute, this.onPop),
    );
  }
}
