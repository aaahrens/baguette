import 'package:baguette/wrapper/wrapper.dart';
import 'package:flutter/cupertino.dart';

class CRouteProvider with ChangeNotifier {
  CRouteProvider._privateConstructor();

  static final CRouteProvider _instance = CRouteProvider._privateConstructor();

  static CRouteProvider get instance => _instance;

  List<CRoute> routes;

  CRoute notFound;

  static List<void Function()> doOnRemove;

  static List<void Function()> doOnInit;
}
