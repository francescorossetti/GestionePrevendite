import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Evento/evento.dart';
import 'package:gestioneprevendite/Pages/Evento/eventoDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:intl/intl.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';

class ListTileEvento extends StatefulWidget {
  final Evento evento;

  ListTileEvento({ Key key, @required this.evento }) : super(key: key);

  @override
  _ListTileEventoState createState() => _ListTileEventoState();
}

class _ListTileEventoState extends State<ListTileEvento> {
@override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(widget.evento.nome, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              Text(new DateFormat("dd/MM/yyyy").format(widget.evento.data), style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, EnterExitRoute(exitPage: EventoList(), enterPage: EventoDetail(evento: widget.evento)));
      },
    );
  }
}