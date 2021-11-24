import 'package:example/bloc/app_state.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  final AppStateBloc appStateBloc;

  const NotFoundPage({Key? key, required this.appStateBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                child: Text("to Dashboard"),
                onPressed: () {
                  appStateBloc.toDashboard();
                }),
            Text("not found"),
          ],
        ),
      ),
    );
  }
}
