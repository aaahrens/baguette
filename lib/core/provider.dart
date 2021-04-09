import 'package:baguette/core/croute.dart';
import 'package:flutter/cupertino.dart';

abstract class CRouteProviderBase {
  final List<CRoute> routes;

  final CRoute notFound;

  /// [doOnRemove]
  List<void Function()> doOnRemove = [];

  /// [doOnInit] occurs at the start of every call to
  List<void Function()> doOnInit = [];

  /// [defaultValueKey]
  ValueKey defaultValueKey = ValueKey("default");

  CRouteProviderBase(this.routes, this.notFound);

  CRoute buildFromState() {
    for (var e in this.routes) {
      if (e.routePage.doesStateMatch) {
        return CRoute(e.template, e.routePage, e.children,
            child: e.parseChildrenFromState());
      }
    }
    return notFound;
  }

  CRoute buildFromUri(Uri uri) {
    for (var e in routes) {
      if (e.isUrlCorrect(uri)) {
        var uriMatch = e.parseUri(uri);
        CRoute? newChild;
        if (uriMatch != null) {
          newChild = e.parseChildren(uriMatch.rest);
          return CRoute(e.template, e.routePage, e.children, child: newChild);
        }
      }
    }
    return notFound;
  }
}

class DefaultCRouteProvider extends CRouteProviderBase with ChangeNotifier {
  ValueKey defaultValueKey = ValueKey("default");

  DefaultCRouteProvider(List<CRoute> routes, CRoute notFound)
      : super(routes, notFound);
}
