import 'package:example/bloc/app_state.dart';
import 'package:flutter/material.dart';

class AnimalForm extends StatefulWidget {
  final String type;
  final AppStateBloc appStateBloc;

  AnimalForm({Key? key, this.type = "cat", required this.appStateBloc})
      : super(key: key);

  @override
  _AnimalFormState createState() => _AnimalFormState(this.appStateBloc);
}

class _AnimalFormState extends State<AnimalForm> {
  final formKey = GlobalKey<FormState>();
  final AppStateBloc appStateBloc;

  String name = "", color = "";

  _AnimalFormState(this.appStateBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name',
              ),
              validator: (String? s) {
                if (s == null || s == "") {
                  return "Cannot be null";
                }
              },
              onChanged: (s) => setState(() {
                name = s;
              }),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Color',
              ),
              validator: (String? s) {
                if (s == null || s == "") {
                  return "Cannot be null";
                }
              },
              onChanged: (s) => setState(() {
                color = s;
              }),
            ),
            ElevatedButton(
              child: Text("go to animal"),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  appStateBloc.toAnimal(
                      this.name, this.color, this.widget.type);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
