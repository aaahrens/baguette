import 'package:flutter/material.dart';
import 'package:uri/uri.dart';

abstract class CRouteBase extends Page {
  final bool renderAsPage;

  Widget get baseComponent;

  CRouteBase({this.renderAsPage = true, this.widgetMap = const {}});

  void parseUriToState(Map<String, String?> params) {}

  bool get doesStateMatch;

  void initState();

  void removeState();

  Set<ValueKey> get valueKey;

  Map<String, String> get variables => {};

  bool shouldRedirect(CRoute? nextRoute) {
    return false;
  }

  void performRedirect() {}

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

  final CRoute? child;
  final CRouteBase routePage;

  const CRoute(this.template, this.routePage, this.children, {this.child});

  bool isUrlCorrect(Uri uri) {
    return UriParser(this.template, queryParamsAreOptional: true).matches(uri);
  }

  _childInitState() {
    this.routePage.initState();
    this.child?._childInitState();
  }

  initState() {
    child?._childInitState();
    this.routePage.initState();
  }

  /// [handlePop] will call [CRouteBase.removeState]] on the last item in the chain
  /// of CRoutes.
  handlePop() {
    var c = this.child;
    if (c == null) {
      this.routePage.removeState();
      return;
    }
    c.handlePop();
  }

  handleRedirect() {
    if (this.routePage.shouldRedirect(this.child)) {
      this.routePage.performRedirect();
    }
    this.child?.handleRedirect();
  }

  ///[uri] is the remaining url post-processing from the current routePage
  ///
  CRoute? parseChildren(Uri uri) {
    for (var shell in this.children) {
      if (shell.isUrlCorrect(uri)) {
        var r = shell.parseUri(uri);
        CRoute? newChild;
        if (r != null) newChild = shell.parseChildren(r.rest);
        return CRoute(shell.template, shell.routePage, shell.children,
            child: newChild);
      }
    }
    return null;
  }

  ///[parseUri] will parse [uri] and call [parseUriToState]
  ///then, it will add it to state and return the [UriMatch] to provide the
  ///remaining uri to its children
  UriMatch? parseUri(Uri uri) {
    var a = UriParser(this.template, queryParamsAreOptional: true).match(uri);
    if (a != null) this.routePage.parseUriToState(a.parameters);
    return a;
  }

  CRoute? parseChildrenFromState() {
    for (var child in this.children) {
      if (child.routePage.doesStateMatch) {
        var subActive = child.parseChildrenFromState();
        return CRoute(child.template, child.routePage, child.children,
            child: subActive);
      }
    }
  }

  UriBuilder get uriBuilder {
    UriBuilder parentBuilder = UriBuilder.fromUri(
        Uri.parse(this.template.expand(this.routePage.variables)));
    if (this.child != null) {
      UriBuilder childBuilder = this.child!.uriBuilder;
      parentBuilder.path = childBuilder.path == ""
          ? parentBuilder.path
          : parentBuilder.path == "/"
              ? "/${childBuilder.path}"
              : "${parentBuilder.path}/${childBuilder.path}";
      parentBuilder.queryParameters.addAll(childBuilder.queryParameters);
    }
    return parentBuilder;
  }

  CRoute? _forKey(ValueKey key) {
    if (this.routePage.valueKey.contains(key)) {
      var subActive = this.child?._forKey(key);
      if (!this.routePage.renderAsPage) return subActive;
      return CRoute(this.template, this.routePage, this.children,
          child: subActive);
    }
    return this.child?._forKey(key);
  }

  CRoute? filterForKey(ValueKey key) {
    var currentChild = this.child;
    if (this.routePage.valueKey.contains(key)) {
      var subActive = currentChild?._forKey(key);
      if (!this.routePage.renderAsPage) return subActive;
      return CRoute(this.template, this.routePage, this.children,
          child: subActive);
    }
    return currentChild?._forKey(key);
  }

  List<Page> toPages() {
    List<Page> a = [this.routePage];
    var currentChild = this.child;
    if (currentChild != null) {
      a.addAll(currentChild.toPages());
    }
    return a;
  }

  Widget firstComponentForKeys(Set<ValueKey> l) {
    var currentChild = this.child;
    if (this.routePage.valueKey.intersection(l).length != 0) {
      return this.routePage.baseComponent;
    }
    if (currentChild == null) return Container();
    return currentChild.firstComponentForKeys(l);
  }

  static deepPrint(CRoute? c) {
    CRoute? tmp = c;
    String space = "  ";
    while (tmp != null) {
      print("$space ${tmp.routePage}");
      space += "  ";
      tmp = tmp.child;
    }
  }
}
