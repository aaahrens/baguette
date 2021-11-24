import 'package:baguette/baguette.dart';
import 'package:flutter/material.dart';

enum AppTab { Dog, Cat, Turtle }

extension TabE on AppTab {
  toInt() {
    switch (this) {
      case AppTab.Dog:
        return 0;
      case AppTab.Cat:
        return 1;
      case AppTab.Turtle:
        return 2;
    }
  }

  static AppTab? fromInt(int i) {
    switch (i) {
      case 0:
        return AppTab.Dog;
      case 1:
        return AppTab.Cat;
      case 2:
        return AppTab.Turtle;
      default:
        return null;
    }
  }

  ValueKey toKey() {
    switch (this) {
      case AppTab.Dog:
        return ValueKey("dog");
      case AppTab.Cat:
        return ValueKey("cat");
      case AppTab.Turtle:
        return ValueKey("turtle");
    }
  }
}

//Our current app state is a singleton, this wrap the default core to a stream for listener for key
class AppStateBloc with ChangeNotifier {
  ValueNotifier<AppState> valueState = ValueNotifier<AppState>(AppState());

  AppState get state => valueState.value;

  Baguette? currentRoute;

  AppStateBloc() {
    valueState.addListener(this.notifyListeners);
  }

  addTab(AppTab? tab) {
    valueState.value.tab = tab;
    valueState.notifyListeners();
  }

  toDashboard() {
    valueState.value = AppState();
    state.isDashboard = true;
    state.tab = AppTab.Dog;
    valueState.notifyListeners();
  }

  toAnimal(String name, String color, String type) {
    state.animalName = name;
    state.animalColor = color;
    state.animalType = type;
    valueState.notifyListeners();
  }

  clearAnimal() {
    state.animalName = null;
    state.animalColor = null;
    state.animalType = null;
    valueState.notifyListeners();
  }
}

class AppState {
  AppTab? tab;
  bool isSettings = false;
  bool isProfile = false;
  bool isDashboard = false;

  String? animalName;
  String? animalColor;
  String? animalType;

  String meow() {
    return "${this.isDashboard} ${this.tab} ${this.animalName} ${this.animalColor}";
  }
}
