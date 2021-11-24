import 'package:baguette/baguette.dart';
import 'package:baguette/core/baguette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isDesktop(BuildContext c) {
  var q = MediaQuery.of(c);
  return q.size.width >= 700;
}

mixin WrapWithScaffoldIfMobile on BaguetteBase {
  @override
  Route createRoute(BuildContext context) {
    if (!isDesktop(context)) {
      return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("automatically wrapped"),
              ),
              body: this.baseComponent,
            );
          },
          settings: this);
    }
    return super.createRoute(context);
  }
}
