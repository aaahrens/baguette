import 'dart:async';

import 'package:example/pages/component/opened_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

enum OpenedProfileTab { Cat, Turtle, Dog }

extension ExOpenProfileTab on OpenedProfileTab {
  int toInt() {
    switch (this) {
      case OpenedProfileTab.Cat:
        return 0;
      case OpenedProfileTab.Dog:
        return 1;
      case OpenedProfileTab.Turtle:
        return 2;
    }
    return -1;
  }

  ValueKey toKey() {
    switch (this) {
      case OpenedProfileTab.Cat:
        return ValueKey("cat-tab");
      case OpenedProfileTab.Turtle:
        return ValueKey("turtle-tab");
      case OpenedProfileTab.Dog:
        return ValueKey("dog-tab");
    }
    return ValueKey("unknown");
  }
}

class AppState with ChangeNotifier {
  bool dashboard;
  String profileOpen;
  bool selfProfile;
  bool settings;
  var currentTab = BehaviorSubject<OpenedProfileTab>();

  List<Function> mutations = [];

  AppState._privateConstructor();

  static AppState _instance = AppState._privateConstructor();

  static AppState get I => _instance;

  setProfileOpen(String p) {
    mutations.add(() {
      profileOpen = p;
      currentTab.add(OpenedProfileTab.Dog);
    });
    finalizeChanges();
  }

  addTab(OpenedProfileTab tab) {
    print("adding tab ${tab}");
    currentTab.add(tab);
    print(currentTab.value);
    notifyListeners();
  }

  batchNextTab(OpenedProfileTab tab){
    print("batching tab");
    currentTab.add(tab);
  }

  clearTab(){
    currentTab.add(null);
    notifyListeners();
  }

  finalizeChanges() {
    for (var m in mutations) {
      m();
    }
    mutations = [];
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    currentTab.close();
  }
}
