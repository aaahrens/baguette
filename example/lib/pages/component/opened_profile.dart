import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:example/bloc/croute.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class OpenedProfilePage extends StatefulWidget {
  @override
  _OpenedProfilePageState createState() => _OpenedProfilePageState();
}

class _OpenedProfilePageState extends State<OpenedProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OpenedProfileTab>(
        stream: AppState.I.currentTab,
        initialData: AppState.I.currentTab.value,
        builder: (context, tab) {
          if (!tab.hasData){
            // AppState.I.addTab(OpenedProfileTab.Dog);
            print("hello ${AppState.I.currentTab.value}");
            // print(CRoute.deepPrint(bRouter.currentRoute));
            // bRouter.currentRoute.initState();
            return Scaffold(
              appBar: AppBar(),
            );
          }
          return StreamBuilder<CRoute>(
              stream: CRouteConversion.I.current,
              initialData: CRouteConversion.I.current.value,
              builder: (context, croute) {
                if (!croute.hasData) {
                  return Scaffold(
                    appBar: AppBar(),
                  );
                }
                return Scaffold(
                    appBar: AppBar(
                        title:
                            Text("opened profile ${AppState.I.profileOpen}")),
                    body: croute.data.baseComponentByKey(tab?.data?.toKey()),
                    floatingActionButton: croute?.data
                        ?.componentByKey(tab?.data?.toKey(), ValueKey("fab")),
                    bottomNavigationBar: BottomNavigationBar(
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.ac_unit), label: "Cat"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.atm_sharp), label: "Dog"),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.arrow_right_sharp),
                            label: "Turtle")
                      ],
                      currentIndex: tab.data?.toInt() ?? 0,
                      onTap: (i) {
                        if (i == 0) AppState.I.addTab(OpenedProfileTab.Cat);
                        if (i == 1) AppState.I.addTab(OpenedProfileTab.Dog);
                        if (i == 2) AppState.I.addTab(OpenedProfileTab.Turtle);
                      },
                    ));
              });
        });
  }
}
