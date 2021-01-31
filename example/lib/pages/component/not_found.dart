import 'package:example/app_state.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("to Dashboard"),
              onPressed: (){
                AppState.I.dashboard = true;
                AppState.I.finalizeChanges();
              },
            ),
            Text("not found"),
          ],
        ),
      ),
    );
  }
}
