import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottopr.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottoprDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';

class ListTileSottoPR extends StatefulWidget {
  final SottoPR sottoPR;

  ListTileSottoPR({ Key key, @required this.sottoPR }) : super(key: key);

  @override
  _ListTileSottoPRState createState() => _ListTileSottoPRState();
}

class _ListTileSottoPRState extends State<ListTileSottoPR> {
  @override
  Widget build(BuildContext context) {
    return InkWell(child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.sottoPR.nome, style: TextStyle(fontSize: 22.0)),
        ),
      ),
      onTap: () {
        Navigator.push(context, EnterExitRoute(exitPage: SottoPRList(), enterPage: SottoPRDetail(sottoPR: widget.sottoPR)));
      },
    );
  }
}