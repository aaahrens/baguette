import 'package:baguette/baguette.dart';
import 'package:example/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AnimalDisplay extends StatelessWidget {
  final String name;
  final String color;
  final appStateBloc = GetIt.I.get<AppStateBloc>();
  final router = GetIt.I.get<BaguetteMaterialRouter>();

  AnimalDisplay({Key? key, this.name = "", this.color = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(router.currentRoute.uriBuilder.build().toString())),
      body: Container(
        child: Column(
          children: [
            Text("showing animal here"),
            Text(
                "showing animal name ${appStateBloc.state.animalName}"),
            Text(
                "showing animal color ${appStateBloc.state.animalColor}"),
            Text(
                "showing animal type ${appStateBloc.state.animalType}"),
            ElevatedButton(
                onPressed: () {
                  appStateBloc.clearAnimal();
                },
                child: Text("edit state directly to go back"))
          ],
        ),
      ),
    );
  }
}
