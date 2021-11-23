import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/pages/components/animal_preview.dart';
import 'package:example/keys.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const DashboardPage({Key? key, required this.appStateBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 700) {
          return DesktopDashboardPage();
        } else {
          return MobileDashboardPage(
            appStateBloc: this.appStateBloc,
          );
        }
      },
    );
  }
}

class DesktopDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DesktopAnimalPreview(),
          DesktopAnimalPreview(),
          DesktopAnimalPreview()
        ],
      ),
    );
  }
}

class MobileDashboardPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const MobileDashboardPage(
      {Key? key, required this.appStateBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppState>(
        valueListenable: appStateBloc.valueState,
        builder: (ctx, appState, child) {
          var currentRoute = appStateBloc.currentRoute;
          if (currentRoute == null) return Container();
          return Scaffold(
              appBar: AppBar(
                  title: Text(currentRoute.uriBuilder.build().toString())),
              body: currentRoute.firstComponentForKeys(tabKeys),
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.ac_unit), label: "Dogs"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.atm_sharp), label: "Cats"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_right_sharp), label: "Turtle")
                ],
                currentIndex: appState.tab?.toInt() ?? 0,
                onTap: (i) => appStateBloc.addTab(TabE.fromInt(i)),
              ));
        });
  }
}
