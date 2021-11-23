import 'package:baguette/core/baguette_base.dart';
import 'package:flutter/material.dart';
import 'package:uri/uri.dart';

class Baguette<T extends BaguetteBase> {
  final UriTemplate template;
  final List<Baguette> children;

  final Baguette? child;
  final BaguetteBase Function() baseFactory;

  const Baguette(this.template, this.baseFactory, this.children, {this.child});

  bool isUrlCorrect(Uri uri) {
    return UriParser(this.template, queryParamsAreOptional: true).matches(uri);
  }

  _childInitState() {
    this.baseFactory().initState();
    this.child?._childInitState();
  }

  initState() {
    child?._childInitState();
    this.baseFactory().initState();
  }

  /// [handlePop] will call [CRouteBase.removeState]] on the last item in the chain
  /// of CRoutes.
  handlePop() {
    var c = this.child;
    if (c == null) {
      this.baseFactory().removeState();
      return;
    }
    c.handlePop();
  }

  ///[uri] is the remaining url post-processing from the current routePage
  ///
  Baguette? parseChildren(Uri uri) {
    for (var shell in this.children) {
      if (shell.isUrlCorrect(uri)) {
        var r = shell.parseUri(uri);
        Baguette? newChild;
        if (r != null) newChild = shell.parseChildren(r.rest);
        return Baguette(shell.template, shell.baseFactory, shell.children,
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
    if (a != null) this.baseFactory().parseUriToState(a.parameters);
    return a;
  }

  Baguette? parseChildrenFromState() {
    for (var child in this.children) {
      if (child.baseFactory().doesStateMatch) {
        var subActive = child.parseChildrenFromState();
        return Baguette(child.template, child.baseFactory, child.children,
            child: subActive);
      }
    }
  }

  UriBuilder get uriBuilder {
    UriBuilder parentBuilder = UriBuilder.fromUri(
        Uri.parse(this.template.expand(this.baseFactory().variables)));
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

  Baguette? _forKey(ValueKey key) {
    if (this.baseFactory().valueKeys.contains(key)) {
      var subActive = this.child?._forKey(key);
      if (!this.baseFactory().shouldRender) return subActive;
      return Baguette(this.template, this.baseFactory, this.children,
          child: subActive);
    }
    return this.child?._forKey(key);
  }

  Baguette? filterForKey(ValueKey key) {
    var currentChild = this.child;
    if (this.baseFactory().valueKeys.contains(key)) {
      var subActive = currentChild?._forKey(key);
      if (!this.baseFactory().shouldRender) return subActive;
      return Baguette(this.template, this.baseFactory, this.children,
          child: subActive);
    }
    return currentChild?._forKey(key);
  }

  List<Page> toPages() {
    List<Page> a = [this.baseFactory()];
    var currentChild = this.child;
    if (currentChild != null) {
      a.addAll(currentChild.toPages());
    }
    return a;
  }

  Widget firstComponentForKeys(Set<ValueKey> l) {
    var currentChild = this.child;
    if (this.baseFactory().valueKeys.intersection(l).length != 0) {
      return this.baseFactory().baseComponent;
    }
    if (currentChild == null) return Container();
    return currentChild.firstComponentForKeys(l);
  }

  static deepPrint(Baguette? c) {
    Baguette? tmp = c;
    String space = "  ";
    while (tmp != null) {
      print("$space ${tmp.baseFactory}");
      space += "  ";
      tmp = tmp.child;
    }
  }
}
