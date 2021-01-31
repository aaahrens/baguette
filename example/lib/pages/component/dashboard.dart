import 'package:baguette/baguette.dart';
import 'package:example/app_state.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("open profile"),
              onPressed: (){
                AppState.I.setProfileOpen("uuid");
              },
            ),
            RaisedButton(
              child: Text("print config"),
              onPressed: (){
                print(CRoute.deepPrint(bRouter.currentRoute));
                print(AppState.I.profileOpen);
                print(AppState.I.dashboard);
              },
            ),
            Text("dashboard page"),
          ],
        ),
      ),
    );
  }
}
