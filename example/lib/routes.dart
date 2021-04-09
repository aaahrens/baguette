import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/keys.dart';
import 'package:example/pages/component/dashboard.dart';
import 'package:example/pages/component/not_found.dart';
import 'package:example/pages/component/settings.dart';
import 'package:example/pages/components/animal_display.dart';
import 'package:example/pages/components/animal_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DashboardRootRoute extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  bool get doesStateMatch => appStateBloc.currentState().isDashboard;

  @override
  initState() {
    appStateBloc.nextState.isDashboard = true;
  }

  @override
  Set<ValueKey> get valueKey =>
      Set.of([ValueKey("desktop"), ValueKey("default")]);

  @override
  removeState() {
    appStateBloc.nextState.isDashboard = false;
  }

  @override
  Widget get baseComponent => DashboardPage();
}

class SettingsRootRoute extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  bool get doesStateMatch => appStateBloc.currentState().isSettings;

  @override
  initState() {
    appStateBloc.nextState.isSettings = true;
  }

  @override
  Widget get baseComponent => SettingsPage();

  @override
  void removeState() {
    appStateBloc.nextState.isSettings = false;
  }

  @override
  Set<ValueKey> get valueKey => Set.of([ValueKey("default")]);
}

class NotFoundRootRoute extends CRouteBase {
  @override
  bool get doesStateMatch => true;

  @override
  initState() {}

  @override
  Widget get baseComponent => NotFoundPage();

  @override
  void removeState() {}

  @override
  Set<ValueKey> get valueKey => Set.of([ValueKey("default")]);
}

/// Tab Routes
class TurtleTab extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  initState() {
    appStateBloc.nextState.tab = AppTab.Turtle;
  }

  @override
  removeState() {
    appStateBloc.nextState.tab = null;
  }

  @override
  Set<ValueKey> get valueKey => Set.of([TurtleKey]);

  @override
  Widget get baseComponent => Container(
        child: Text("turtle tab"),
      );

  @override
  bool get doesStateMatch => appStateBloc.currentState().tab == AppTab.Turtle;
}

class CatTab extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  Widget get baseComponent => Center(
        child: Container(
          child: Text("cat tab"),
        ),
      );

  @override
  bool get doesStateMatch => appStateBloc.currentState().tab == AppTab.Cat;

  @override
  Set<ValueKey> get valueKey => Set.from([CatKey]);

  @override
  initState() {
    appStateBloc.nextState.tab = AppTab.Cat;
  }

  @override
  removeState() {
    appStateBloc.nextState.tab = null;
  }
}

class DogTab extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  Set<ValueKey> get valueKey => Set.of([DogKey]);

  @override
  bool get doesStateMatch => appStateBloc.currentState().tab == AppTab.Dog;

  @override
  Widget get baseComponent => AnimalForm(type: "dog");

  @override
  initState() {
    appStateBloc.nextState.tab = AppTab.Dog;
  }

  @override
  removeState() {
    appStateBloc.nextState.tab = null;
  }
}

class AnimalRoute extends CRouteBase {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

  @override
  Widget get baseComponent => AnimalDisplay();

  @override
  bool get doesStateMatch =>
      appStateBloc.currentState().animalName != null &&
      appStateBloc.currentState().animalColor != null;

  @override
  void initState() {}

  @override
  void removeState() {}

  @override
  void parseUriToState(Map<String, String?> params) {
    appStateBloc.nextState.animalName = params["animal_name"];
    appStateBloc.nextState.animalColor = params["animal_type"];
    appStateBloc.nextState.animalType = params["animal_color"];
  }

  @override
  Map<String, String> get variables => {
        "animal_name": appStateBloc.currentState().animalName ?? "",
        "animal_type": appStateBloc.currentState().animalType ?? "",
        "animal_color": appStateBloc.currentState().animalColor ?? "",
      };

  @override
  Set<ValueKey> get valueKey => Set.of([ValueKey("default"), AnimalKey]);
}
