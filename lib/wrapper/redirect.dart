import 'package:flutter/material.dart';

class CRedirect extends StatefulWidget {
  final Function first;

  const CRedirect(this.first, {Key key}) : super(key: key);

  @override
  _CRedirectState createState() => _CRedirectState();
}

class _CRedirectState extends State<CRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => this.widget.first());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
