import 'package:example/pages/components/animal_form.dart';
import 'package:flutter/material.dart';

class DogTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimalForm(type: "dog");
  }
}
