import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/keys.dart';
import 'package:example/pages/dashboard.dart';
import 'package:example/pages/dog_tab.dart';
import 'package:example/pages/not_found.dart';
import 'package:example/pages/settings.dart';
import 'package:example/pages/components/animal_display.dart';
import 'package:example/route_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardRootRoute extends BaguetteBase
    with WithDefaultKeys, WithDesktopKeys, AlwaysRender {
  final AppStateBloc appStateBloc;

  DashboardRootRoute(this.appStateBloc);

  @override
  bool get doesStateMatch => appStateBloc.state.isDashboard;

  @override
  initState() {
    appStateBloc.valueState.value.isDashboard = true;
  }

  @override
  removeState() {
    appStateBloc.valueState.value.isDashboard = false;
  }

  @override
  Widget get baseComponent => DashboardPage(
        appStateBloc: appStateBloc,
      );
}

class SettingsRootRoute extends BaguetteBase with AlwaysRender {
  final AppStateBloc appStateBloc;

  SettingsRootRoute(this.appStateBloc);

  @override
  bool get doesStateMatch => appStateBloc.state.isSettings;

  @override
  initState() {
    appStateBloc.state.isSettings = true;
  }

  @override
  Widget get baseComponent => SettingsPage();

  @override
  void removeState() {
    appStateBloc.state.isSettings = false;
  }
}

class NotFoundRootRoute extends BaguetteBase {
  final AppStateBloc appStateBloc;

  NotFoundRootRoute(this.appStateBloc);

  @override
  bool get doesStateMatch => true;

  @override
  initState() {}

  @override
  Widget get baseComponent => NotFoundPage(
        appStateBloc: this.appStateBloc,
      );

  @override
  void removeState() {}

  @override
  Set<ValueKey> get valueKeys => Set.of([ValueKey("default")]);
}

/// Tab Routes
class TurtleTab extends BaguetteBase {
  final AppStateBloc appStateBloc;

  TurtleTab(this.appStateBloc);

  @override
  initState() {
    appStateBloc.state.tab = AppTab.Turtle;
  }

  @override
  removeState() {
    appStateBloc.state.tab = null;
  }

  @override
  Set<ValueKey> get valueKeys => Set.of([TurtleKey]);

  @override
  Widget get baseComponent => Container(
        child: Text("turtle tab"),
      );

  @override
  bool get doesStateMatch => appStateBloc.state.tab == AppTab.Turtle;
}

class CatTab extends BaguetteBase {
  final AppStateBloc appStateBloc;

  CatTab(this.appStateBloc);

  @override
  Widget get baseComponent => Center(
        child: Container(
          child: Text("cat tab"),
        ),
      );

  @override
  bool get doesStateMatch => appStateBloc.state.tab == AppTab.Cat;

  @override
  Set<ValueKey> get valueKeys => Set.from([CatKey, DeskTopKey]);

  @override
  initState() {
    appStateBloc.state.tab = AppTab.Cat;
  }

  @override
  removeState() {
    appStateBloc.state.tab = null;
  }
}

class DogTab extends BaguetteBase with WrapWithScaffoldIfMobile {
  final AppStateBloc appStateBloc;

  DogTab(this.appStateBloc);

  @override
  Set<ValueKey> get valueKeys => Set.of([DogKey]);

  @override
  bool get doesStateMatch => appStateBloc.state.tab == AppTab.Dog;

  @override
  Widget get baseComponent => DogTabPage(appStateBloc: this.appStateBloc);

  @override
  initState() {
    appStateBloc.state.tab = AppTab.Dog;
  }

  @override
  removeState() {
    appStateBloc.state.tab = null;
  }
}

class AnimalRoute extends BaguetteBase with WrapWithScaffoldIfMobile {
  final AppStateBloc appStateBloc;

  AnimalRoute(this.appStateBloc);

  @override
  Widget get baseComponent => AnimalDisplay(appStateBloc: this.appStateBloc);

  @override
  bool get doesStateMatch =>
      appStateBloc.state.animalName != null &&
      appStateBloc.state.animalColor != null;

  @override
  void initState() {}

  @override
  void removeState() {

    appStateBloc.valueState.value.animalName = null;
    appStateBloc.valueState.value.animalColor = null;
    appStateBloc.valueState.value.animalType = null;
  }

  @override
  void parseUriToState(Map<String, String?> params) {
    appStateBloc.valueState.value.animalName = params["animal_name"];
    appStateBloc.valueState.value.animalColor = params["animal_type"];
    appStateBloc.valueState.value.animalType = params["animal_color"];
  }

  @override
  Map<String, String> get variables => {
        "animal_name": appStateBloc.state.animalName ?? "unknown",
        "animal_type": appStateBloc.state.animalType ?? "unknown",
        "animal_color": appStateBloc.state.animalColor ?? "unknown",
      };

  @override
  Set<ValueKey> get valueKeys => Set.of([AnimalKey, ...tabKeys]);
}
