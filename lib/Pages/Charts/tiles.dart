import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  const Tiles(this.backgroundColor, this.widget);

  final Color backgroundColor;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: new Center(
        child: new Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(children: <Widget>[
          widget
        ])
        ),
      ),
    );
  }
}