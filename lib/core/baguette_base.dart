import 'package:flutter/material.dart';

/// [BaguetteBase]
abstract class BaguetteBase extends Page {
  /// [doesStateMatch]
  bool get doesStateMatch;

  /// [shouldRender] determines behaviour in [Baguette.toPages]. If
  /// [doesStateMatch] returns true, but this is set to false, the baseComponent
  /// will not be called in the returned [Page] stack;
  bool get shouldRender => true;

  /// [baseComponent]
  Widget get baseComponent;

  Set<ValueKey> get valueKeys => Set.of([]);

  /// [variables] determine what params get passed into [parseUriToState]
  Map<String, String> get variables => {};

  const BaguetteBase();

  void parseUriToState(Map<String, String?> params) {}

  void initState();

  void removeState();

  void performRedirect() {}

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (c) => this.baseComponent);
  }
}
