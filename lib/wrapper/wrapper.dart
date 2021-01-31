import 'package:baguette/wrapper/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uri/uri.dart';

final ValueKey<String> defaultKey = ValueKey("defaultCRouteKey");

abstract class CRouteBase extends Page {
  final bool renderAsPage;

  CRouteBase(
      {this.renderAsPage = true,
      this.baseComponent,
      this.widgetMap = const {}});

  void parseUriToState(Map<String, String> params) {}

  bool get doesStateMatch;

  initState();

  removeState() {}

  ValueKey get valueKey => defaultKey;

  Map<String, String> get variables => {};

  bool shouldRedirect(CRoute nextRoute) {
    return false;
  }

  void performRedirect() {}

  final Widget baseComponent;

  final Map<ValueKey, Widget Function()> widgetMap;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (c) => this.baseComponent);
  }
}

class CRoute {
  final UriTemplate template;
  final List<CRoute> children;

  final CRoute child;
  final CRouteBase routePage;

  const CRoute(this.template, this.routePage, this.children, {this.child});

  bool isUrlCorrect(Uri uri) {
    return UriParser(this.template, queryParamsAreOptional: true).matches(uri);
  }
  _childInitState(){
    this.routePage.initState();
    if(this.child != null) this.child._childInitState();
  }

  initState() {
    if (child != null) child._childInitState();
    this.routePage.initState();
    if (child == null) {
      for (var func in CRouteProvider.doOnInit) {
        func();
      }
    }
  }

  _handleChildPop() {
    this.routePage.removeState();
    if (this.child == null) return;
  }

  handlePop() {
    if (this.child != null) {
      this.child._handleChildPop();
    }
    this.routePage.removeState();
    for (var f in CRouteProvider.doOnRemove) {
      f();
    }
  }

  handleRedirect() {
    if (this.routePage.shouldRedirect(this.child)) {
      this.routePage.performRedirect();
    }
    this.child?.handleRedirect();
  }

  ///[uri] is the remaining url post-processing from the current routePage
  ///
  CRoute parseChildren(Uri uri) {
    for (var shell in this.children) {
      if (shell.isUrlCorrect(uri)) {
        var r = shell.parseUri(uri);
        var newChild = shell.parseChildren(r.rest);
        return CRoute(shell.template, shell.routePage, shell.children,
            child: newChild);
      }
    }

    return null;
  }

  ///[parseUri] will parse [uri] and call [parseUriToState]
  ///then, it will add it to state and return the [UriMatch] to provide the
  ///remaining uri to its children
  UriMatch parseUri(Uri uri) {
    var a = UriParser(this.template, queryParamsAreOptional: true).match(uri);
    this.routePage.parseUriToState(a.parameters);
    return a;
  }

  CRoute _parseChildrenFromState() {
    if (this.children.length == 0) return null;
    for (var child in this.children) {
      if (child.routePage.doesStateMatch ?? false) {
        var subActive = child._parseChildrenFromState();
        return CRoute(child.template, child.routePage, child.children,
            child: subActive);
      }
    }
    return null;
  }

  UriBuilder get uriBuilder {
    UriBuilder builder = UriBuilder.fromUri(
        Uri.parse(this.template.expand(this.routePage.variables)));
    if (this.child != null) {
      UriBuilder i = this.child.uriBuilder;
      builder.path = "${builder.path}/${i.path}";
      builder.queryParameters.addAll(i.queryParameters);
    }
    return builder;
  }

  CRoute _forKey(ValueKey key) {
    if (this.routePage.valueKey == key) {
      var subActive = this.child?._forKey(key);
      if (!this.routePage.renderAsPage) return subActive;
      return CRoute(this.template, this.routePage, this.children,
          child: subActive);
    }
    return this.child?._forKey(key);
  }

  CRoute filterForKey([ValueKey key]) {
    var keyToUse = key ?? defaultKey;
    if (this.routePage.valueKey == keyToUse) {
      var subActive = this.child?._forKey(keyToUse);
      if (!this.routePage.renderAsPage) return subActive;
      return CRoute(this.template, this.routePage, this.children,
          child: subActive);
    }
    return this.child?._forKey(keyToUse);
  }

  List<Page> toPages() {
    List<Page> a = [this.routePage];
    if (this.child != null) {
      a.addAll(this.child.toPages());
    }
    return a;
  }

  static deepPrint(CRoute c) {
    CRoute tmp = c;
    String space = "  ";
    while (tmp != null) {
      print("$space ${tmp.routePage}");
      space += "  ";
      tmp = tmp.child;
    }
  }

  static CRoute buildFromState() {
    for (var e in CRouteProvider.instance.routes) {
      if (e.routePage.doesStateMatch ?? false) {
        CRoute subActive = e._parseChildrenFromState();
        return CRoute(e.template, e.routePage, e.children, child: subActive);
      }
    }
    return CRouteProvider.instance.notFound;
  }

  static CRoute loadStateFromUri(Uri uri) {
    CRoute toReturn;
    for (var e in CRouteProvider.instance.routes) {
      if (e.isUrlCorrect(uri)) {
        var uriMatch = e.parseUri(uri);
        var newChild = e.parseChildren(uriMatch.rest);
        toReturn = CRoute(e.template, e.routePage, e.children, child: newChild);
      }
    }
    if (toReturn == null) toReturn = CRouteProvider.instance.notFound;
    for (var func in CRouteProvider.doOnInit) {
      func();
    }
    return toReturn;
  }

  Widget baseComponentByKey(ValueKey key) {
    if (this.routePage.valueKey == key) {
      return this.routePage.baseComponent;
    }
    if (this.child == null) return null;
    return this.child.baseComponentByKey(key);
  }

  Widget componentByKey(ValueKey key, ValueKey key2) {
    return null;
  }

  CRoute lastByKey([ValueKey key]) {
    var keyToUse = key ?? defaultKey;
    if (this.child == null) {
      //reached the bottom of the stack
      return CRoute(this.template, this.routePage, this.children);
    } else {
      var nestedChild = this.child.lastByKey(keyToUse);
      if (nestedChild.routePage.valueKey == keyToUse) {
        //already complete, pass upward
        return nestedChild;
      }
      // returns self if chain not complete, parent will check
      return CRoute(this.template, this.routePage, this.children,
          child: nestedChild);
    }
  }
}
