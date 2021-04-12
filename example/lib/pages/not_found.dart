import 'package:example/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotFoundPage extends StatelessWidget {
  final appStateBloc = GetIt.I.get<AppStateBloc>();

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
