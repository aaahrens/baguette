import 'package:baguette/core/croute.dart';
import 'package:flutter/cupertino.dart';

abstract class CRouteProviderBase {
  final List<CRoute> routes;

  final CRoute notFound;

  /// [doOnRemove]
  List<void Function()> doOnRemove = [];

  /// [doOnInit] occurs at the start of every call
  /// to [buildFromState] and [buildFromUri]
  List<void Function()> doOnInit = [];

  /// [doPostInit] occurs at the end of [buildFromState] and [buildFromUri]
  /// It can be used to emit new events, write state, log analytics etc.
  List<void Function()> doPostInit = [];

  /// [defaultValueKey]
  ValueKey defaultValueKey = ValueKey("default");

  CRouteProviderBase(this.routes, this.notFound);

  /// [buildFromState] will construct a CRoute from the existing state, using
  /// [CRouteProviderBase.doesStateMatch] and parsing [CRouteProviderBase.variables]
  /// to example uri templates.
  /// It does not call any lifecycle methods; that responsibility is designated
  /// to the caller.
  CRoute buildFromState() {
    performInit();
    var toReturn = notFound;
    for (var e in this.routes) {
      if (e.routePage.doesStateMatch) {
        toReturn = CRoute(e.template, e.routePage, e.children,
            child: e.parseChildrenFromState());
      }
    }
    performPostInit();
    return toReturn;
  }
  /// [buildFromUri] will construct a CRoute from a well formed Uri.
  /// It does not call any lifecycle methods; that responsibility is designated
  /// to the caller.
  CRoute buildFromUri(Uri uri) {
    performInit();
    var toReturn = notFound;
    for (var e in routes) {
      if (e.isUrlCorrect(uri)) {
        var uriMatch = e.parseUri(uri);
        CRoute? newChild;
        if (uriMatch != null) {
          newChild = e.parseChildren(uriMatch.rest);
          toReturn =
              CRoute(e.template, e.routePage, e.children, child: newChild);
          break;
        }
      }
    }
    performPostInit();
    return toReturn;
  }

  performInit() {
    for (var f in this.doOnInit) {
      f();
    }
  }

  performPostInit() {
    for (var f in this.doPostInit) {
      f();
    }
  }
}

class DefaultCRouteProvider extends CRouteProviderBase with ChangeNotifier {
  ValueKey defaultValueKey = ValueKey("default");

  DefaultCRouteProvider(List<CRoute> routes, CRoute notFound)
      : super(routes, notFound);
}
