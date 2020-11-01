import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Evento/ListTileEvento.dart';
import 'package:gestioneprevendite/Pages/Evento/eventoDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/PDFProvider.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/Pages/Utils/emptyList.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/services/Evento.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:grouped_list/grouped_list.dart';

class EventoList extends StatefulWidget {
  @override
  _EventoListState createState() => _EventoListState();
}

class _EventoListState extends State<EventoList> {
  List<Evento> eventi = new List<Evento>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () async { 
            String file = await PDFProvider.pdfEventi(context);
            PDFProvider.shareFile(AppLocalizations.of(context).translate("eventi"), file);
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              EnterExitRoute(exitPage: EventoList(), enterPage: EventoDetail(evento: null))
            );
          },
        )
      ]),
      bottomNavigationBar: MyNavigationBar(),
      body: FutureBuilder(
        future: new EventoService().getEventi(),
        builder: (BuildContext context, AsyncSnapshot<List<Evento>> snapshot) {
          if(snapshot.hasData){
            if(snapshot.data != this.eventi) {
              this.eventi = snapshot.data;
              return snapshot.data.length > 0 ? Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: GroupedListView(
                  elements: snapshot.data,
                  groupBy:  (element) => element.fkLocale.idAzienda,
                  groupSeparatorBuilder: _buildGroupSeparator,
                  itemBuilder: (context, element) => ListTileEvento(evento: element),
                  order: GroupedListOrder.ASC,
              )) : EmptyListPlaceHolder(title: AppLocalizations.of(context).translate("nessun_evento"), descrizione: AppLocalizations.of(context).translate("nessun_evento_desc"), image:  AssetImage('assets/images/events_add.png'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Center(child: Text(this.eventi.where((x) => x.fkLocale.idAzienda == groupByValue).toList()[0].fkLocale.nome.toUpperCase(),
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)));
  }
}