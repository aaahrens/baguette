import 'dart:async';

import 'package:baguette/baguette.dart';
import 'package:example/main.dart';
import 'package:rxdart/rxdart.dart';

//Our current app state is a singleton, this wrap the default wrapper to a stream for listener for key
class CRouteConversion {
  var current = BehaviorSubject<CRoute>();

  CRouteConversion._privateConstructor();

  static CRouteConversion _instance = CRouteConversion._privateConstructor();

  static CRouteConversion get I => _instance;

  void addCurrentCRouteToStream() {
    current.add(bRouter.currentRoute);
  }
}
