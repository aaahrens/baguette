import 'package:baguette/core/croute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isDesktop(BuildContext c) {
  var q = MediaQuery.of(c);
  return q.size.width >= 700;
}

mixin WrapWithScaffoldDesktopWidget on CRouteBase {
  @override
  Route createRoute(BuildContext context) {
    if (isDesktop(context)) {
      return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(),
              body: this.baseComponent,
            );
          },
          settings: this);
    }
    return super.createRoute(context);
  }
}
