import 'package:baguette/core/baguette.dart';
import 'package:baguette/core/composer.dart';
import 'package:flutter/material.dart';


class TestState {
  bool isCats;
  String? catName;

  TestState({required this.isCats, this.catName});
}

class RootRoute extends CRouteBase {
  final TestState state;

  RootRoute(this.state);

  @override
  bool get doesStateMatch => true;

  @override
  void initState() {}

  @override
  void removeState() {}

  @override
  Widget get baseComponent => Container();

  @override
  Set<ValueKey> get valueKey => Set.of([ValueKey("default")]);
}

class CatRoute extends CRouteBase {
  final TestState state;

  CatRoute(this.state);

  @override
  bool get doesStateMatch => this.state.isCats;

  @override
  initState() {
    state.isCats = true;
  }

  @override
  removeState() {}

  @override
  Widget get baseComponent => Container();

  @override
  Set<ValueKey> get valueKey => Set.of([ValueKey("default")]);
}

class NamedCatRoute extends CRouteBase {
  final TestState state;

  String? catName;

  NamedCatRoute(this.state);

  @override
  Widget get baseComponent => Container();

  @override
  bool get doesStateMatch => state.catName != null;

  @override
  void initState() {
    state.catName = this.catName;
  }

  @override
  void removeState() {
    state.catName = null;
  }

  @override
  Map<String, String> get variables => {"catname": this.catName ?? ""};

  @override
  void parseUriToState(Map<String, String?> params) {
    this.catName = params["catname"];
  }

  @override
  Set<ValueKey> get valueKey => throw UnimplementedError();
}
