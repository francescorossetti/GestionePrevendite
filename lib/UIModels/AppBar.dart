import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final List<Widget> widgets;

  MyAppBar({ Key key, this.title, this.widgets }) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      title: Text(widget.title, style: TextStyle(color: Colors.white)),
      actions: widget.widgets,
    );
  }
}