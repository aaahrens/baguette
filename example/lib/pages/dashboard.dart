import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/pages/components/animal_preview.dart';
import 'package:example/keys.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 700) {
          return DesktopDashboardPage();
        } else {
          return MobileDashboardPage();
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
  final appStateBloc = GetIt.I.get<AppStateBloc>();
  final router = GetIt.I.get<BaguetteMaterialRouter>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppState>(
        valueListenable: appStateBloc.valueState,
        builder: (ctx, appState, child) {
          var currentRoute = router.currentRoute;
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
