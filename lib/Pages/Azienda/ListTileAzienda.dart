import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Azienda/azienda.dart';
import 'package:gestioneprevendite/Pages/Azienda/aziendaDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';

class ListTileAzienda extends StatefulWidget {
  final Azienda azienda;

  ListTileAzienda({ Key key, @required this.azienda }) : super(key: key);

  @override
  _ListTileAziendaState createState() => _ListTileAziendaState();
}

class _ListTileAziendaState extends State<ListTileAzienda> {
  @override
  Widget build(BuildContext context) {
    return InkWell(child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.azienda.nome, style: TextStyle(fontSize: 22.0)),
        ),
      ),
      onTap: () {
        Navigator.push(context, EnterExitRoute(exitPage: AziendaList(), enterPage: AziendaDetail(azienda: widget.azienda)));
      },
    );
  }
}