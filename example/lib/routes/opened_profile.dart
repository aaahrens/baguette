import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:flutter/cupertino.dart';

class TurtleTab extends CRouteBase {
  @override
  initState() {
    AppState.I.currentTab.add(OpenedProfileTab.Turtle);
  }

  @override
  removeState() {
    AppState.I.mutations.add(() {
      AppState.I.clearTab();
    });
  }

  @override
  ValueKey get valueKey => ValueKey("turtle-tab");

  @override
  Widget get baseComponent => Container(
        child: Text("turtle tab"),
      );

  @override
  bool get doesStateMatch => AppState.I.currentTab.value == OpenedProfileTab.Turtle;
}

class CatTab extends CRouteBase {
  @override
  Widget get baseComponent => Center(
    child: Container(
          child: Text("cat tab"),
        ),
  );

  @override
  bool get doesStateMatch => AppState.I.currentTab.value == OpenedProfileTab.Cat;

  @override
  ValueKey get valueKey => ValueKey("cat-tab");

  @override
  initState() {
    AppState.I.addTab(OpenedProfileTab.Cat);
  }

  @override
  removeState() {
    AppState.I.mutations.add(() {
      AppState.I.clearTab();
    });
  }


}

class DogTab extends CRouteBase {
  @override
  ValueKey get valueKey => ValueKey("dog-tab");

  @override
  bool get doesStateMatch => AppState.I.currentTab.value == OpenedProfileTab.Dog;

  @override
  initState() {
    AppState.I.currentTab.add(OpenedProfileTab.Dog);
  }

  @override
  Widget get baseComponent => Container(
        child: Text("dog tab"),
      );

  @override
  removeState() {
    AppState.I.mutations.add(() {
      AppState.I.clearTab();
    });
  }

}
