import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Prevendita/prevendita.dart';
import 'package:gestioneprevendite/Pages/Prevendita/prevenditaDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class ListTilePrevendita extends StatefulWidget {
  final Prevendita prevendita;

  ListTilePrevendita({ Key key, @required this.prevendita }) : super(key: key);

  @override
  _ListTilePrevenditaState createState() => _ListTilePrevenditaState();
}

class _ListTilePrevenditaState extends State<ListTilePrevendita> {
@override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("ID: " + widget.prevendita.idPrevendita.toString(), style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              Text(AppLocalizations.of(context).translate("costo") + widget.prevendita.costoPrevendita.toString(), style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal)),
              widget.prevendita.vendutaDa != null ? Text(AppLocalizations.of(context).translate("venduta_da") + widget.prevendita.vendutaDa.nome, style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.normal)) : Container(),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(context, EnterExitRoute(exitPage: PrevenditaList(), enterPage: PrevenditaDetail(prevendita: widget.prevendita)));
      },
    );
  }
}