import 'package:baguette/core/baguette.dart';
import 'package:flutter/cupertino.dart';

abstract class BaguetteComposer {
  /// [routes] are the totality list of routes that can exist
  final List<Baguette> routes;

  /// [notFound] is the route shown or instantiated if no routes match
  final Baguette notFound;

  /// [doOnRemove]
  List<void Function()> doOnRemove = [];

  /// [doOnInit] occurs at the start of every call
  /// to [buildFromState] and [buildFromUri]
  List<void Function()> doOnInit = [];

  /// [doPostInit] occurs at the end of [buildFromState] and [buildFromUri]
  /// It can be used to emit new events, write state, log analytics etc.
  List<void Function()> doPostInit = [];

  /// [defaultValueKey]
  ValueKey get defaultValueKey;

  BaguetteComposer(this.routes, this.notFound);

  /// [buildFromState] will construct a CRoute from the existing state, using
  /// [BaguetteComposer.doesStateMatch] and parsing [BaguetteComposer.variables]
  /// to example uri templates.
  /// It does not call any lifecycle methods; that responsibility is designated
  /// to the caller.
  Baguette buildFromState() {
    performInit();
    var toReturn = notFound;
    for (var e in this.routes) {
      if (e.baseFactory().doesStateMatch) {
        toReturn = Baguette(e.template, e.baseFactory, e.children,
            child: e.parseChildrenFromState());
      }
    }
    performPostInit();
    return toReturn;
  }

  /// [buildFromUri] will construct a CRoute from a well formed Uri.
  /// It does not call any lifecycle methods; that responsibility is designated
  /// to the caller.
  /// It is best to use this with
  Baguette buildFromUri(Uri uri) {
    performInit();
    var toReturn = notFound;
    for (var e in routes) {
      if (e.isUrlCorrect(uri)) {
        var uriMatch = e.parseUri(uri);
        Baguette? newChild;
        if (uriMatch != null) {
          newChild = e.parseChildren(uriMatch.rest);
          toReturn =
              Baguette(e.template, e.baseFactory, e.children, child: newChild);
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

class DefaultCRouteProvider extends BaguetteComposer with ChangeNotifier {
  final ValueKey dk;
  DefaultCRouteProvider(List<Baguette> routes, Baguette notFound, this.dk)
      : super(routes, notFound);

  @override
  ValueKey get defaultValueKey => this.dk;
}
