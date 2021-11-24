import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:example/pages/components/animal_preview.dart';
import 'package:example/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DashboardPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const DashboardPage({Key? key, required this.appStateBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 700) {
          return DesktopDashboardPage(bloc: this.appStateBloc);
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
  final AppStateBloc bloc;

  const DesktopDashboardPage({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: ListView(
              children: [
                ListTile(
                    leading: const Icon(Icons.flight_land),
                    title: const Text("Dogs"),
                    selected: bloc.state.tab == AppTab.Dog,
                    onTap: () {
                      bloc.addTab(AppTab.Dog);
                    }),
                ListTile(
                    leading: const Icon(Icons.ac_unit_sharp),
                    title: const Text("Cats"),
                    selected: bloc.state.tab == AppTab.Cat,
                    onTap: () {
                      bloc.addTab(AppTab.Cat);
                    }),
                ListTile(
                    leading: const Icon(Icons.arrow_upward_sharp),
                    selected: bloc.state.tab == AppTab.Turtle,
                    title: const Text("Turtles"),
                    onTap: () {
                      bloc.addTab(AppTab.Turtle);
                    })
              ],
            ),
          ),
          if (this.bloc.state.tab == AppTab.Dog)
            Flexible(
              child: DogTabListener(bloc: this.bloc),
            )
        ],
      ),
    );
  }
}

class MobileDashboardPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const MobileDashboardPage({Key? key, required this.appStateBloc})
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

class DogTabListener extends StatefulWidget {
  final AppStateBloc bloc;

  const DogTabListener({Key? key, required this.bloc}) : super(key: key);

  @override
  _DogTabListenerState createState() => _DogTabListenerState(this.bloc);
}

class _DogTabListenerState extends State<DogTabListener>
    with SingleTileListenerForKey {
  final AppStateBloc bloc;

  _DogTabListenerState(this.bloc);

  @override
  Baguette<BaguetteBase> get currentCRoute => bloc.currentRoute!;

  @override
  ValueKey get filterKey => DogKey;

  @override
  Widget get loadingScreen => Text("loading");

  @override
  void Function(Baguette<BaguetteBase>? newCroute) get onPop => (s) {
        s?.handlePop();
      };
}
