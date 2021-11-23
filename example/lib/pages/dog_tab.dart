import 'package:example/bloc/app_state.dart';
import 'package:example/pages/components/animal_form.dart';
import 'package:flutter/material.dart';

class DogTabPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const DogTabPage({Key? key, required this.appStateBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimalForm(
      type: "dog",
      appStateBloc: this.appStateBloc,
    );
  }
}
