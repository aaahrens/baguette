import 'dart:async';

import 'package:baguette/baguette.dart';
import 'package:baguette/core/baguette.dart';
import 'package:flutter/material.dart';

/// [SingleTileListenerForKey]
mixin SingleTileListenerForKey<T extends StatefulWidget> on State<T> {
  ValueKey get filterKey;

  Widget get loadingScreen;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Baguette get currentCRoute;

  void Function(Baguette? newCroute) get onPop;

  @override
  Widget build(BuildContext context) {

    return Router(
      routerDelegate:
          CRouter(this.navigatorKey, this.currentCRoute.filterForKey(this.filterKey)!, this.onPop),
    );
  }
}
