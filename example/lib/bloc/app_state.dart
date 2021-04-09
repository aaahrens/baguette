import 'dart:async';

import 'package:baguette/baguette.dart';
import 'package:example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

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
  AppState nextState = AppState();
  BehaviorSubject<AppState> stream =
      BehaviorSubject<AppState>.seeded(AppState());

  clear() {
    nextState = AppState();
  }

  addTab(AppTab? tab) {
    var currentState = stream.value;
    if (currentState == null) {
      return;
    }
    currentState.tab = tab;
    stream.add(currentState);
    notifyListeners();
  }

  toDashboard() {
    stream.add(AppState(isDashboard: true));
    notifyListeners();
  }

  toAnimal(String name, String color, String type) {
    var currentState = stream.value;
    if (currentState == null) {
      return;
    }
    currentState.animalName = name;
    currentState.animalColor = color;
    currentState.animalType = type;
    notifyListeners();
  }

  AppState currentState() {
    return stream.value ?? AppState();
  }

  emit() {
    stream.add(nextState);
  }
}

class AppState {
  AppTab? tab;
  bool isSettings = false;
  bool isProfile = false;
  bool isDashboard;

  String? animalName;
  String? animalColor;
  String? animalType;

  AppState({this.isDashboard = false});
}
