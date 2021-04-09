import 'dart:async';

import 'package:baguette/baguette.dart';
import 'package:baguette/core/croute.dart';
import 'package:flutter/material.dart';

mixin CRouteListenerForKey<T extends StatefulWidget> on State<T> {
  Stream<CRoute> get handlerStream;

  ValueKey get filterKey;

  Widget get loadingScreen;

  late GlobalKey<NavigatorState> navigatorKey;

  late CRoute currentCRoute;

  late StreamSubscription _sub;

  void Function(CRoute newCroute) get onPop;

  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
    _sub.cancel();
    Future.delayed(Duration.zero, _listenToRouteChanges);
  }

  _listenToRouteChanges() {
    handlerStream.listen((event) {
      // this.currentCRoute = event.filterForKey(this.filterKey);
      // if (this.mounted) {
      //   setState(() {});
      // }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this.currentCRoute == null) {
      return this.loadingScreen;
    }
    return Router(
      routerDelegate:
          CRouter(this.navigatorKey, this.currentCRoute, this.onPop),
    );
  }
}
