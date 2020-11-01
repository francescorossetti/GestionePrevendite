import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Utils/PDFProvider.dart';
import 'package:gestioneprevendite/Pages/Prevendita/ListTilePrevendita.dart';
import 'package:gestioneprevendite/Pages/Prevendita/prevenditaDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/Pages/Utils/emptyList.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:intl/intl.dart';

class PrevenditaList extends StatefulWidget {
  @override
  _PrevenditaListState createState() => _PrevenditaListState();
}

class _PrevenditaListState extends State<PrevenditaList> {
  List<Prevendita> prevendite = new List<Prevendita>();
  List<Evento> eventi = new List<Evento>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        PopupMenuButton<Evento>(
          elevation: 3.2,
          icon: Icon(Icons.share),
          onCanceled: () {
          },
          onSelected: (item) async {
            String file = await PDFProvider.pdfPrevendite(context, item);
            PDFProvider.shareFile(AppLocalizations.of(context).translate("prevendite"), file);
          },
          itemBuilder: (BuildContext context) {
            return eventi.map((Evento evento) {
              return PopupMenuItem<Evento>(
                value: evento,
                child: Text(evento.nome),
              );
            }).toList();
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              EnterExitRoute(exitPage: PrevenditaList(), enterPage: PrevenditaDetail(prevendita: null))
            );
          },
        )
      ]),
      bottomNavigationBar: MyNavigationBar(),
      body: FutureBuilder(
        future: new PrevenditaService().getPrevendite(),
        builder: (BuildContext context, AsyncSnapshot<List<Prevendita>> snapshot) {
          if(snapshot.hasData){
            this.prevendite = snapshot.data;
            getEventi();
            return snapshot.data.length > 0 ? Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListView.builder(
                itemCount: eventi.length,
                itemBuilder: (context, i) {
                  return new ExpansionTile(
                    title: _buildGroupSeparator(eventi[i]),
                    children: <Widget>[
                      new Column(
                        children: _buildExpandableContent(eventi[i]),
                      ),
                    ],
                  );
                },
              )
            ) : EmptyListPlaceHolder(title: AppLocalizations.of(context).translate("nessuna_prevendita"), descrizione: AppLocalizations.of(context).translate("nessuna_prevendita_desc"), image:  AssetImage('assets/images/tickets_add.png'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }

  _buildExpandableContent(Evento evento) {
    List<Widget> columnContent = [];
      
    this.prevendite.where((x) => x.fkEvento.idEvento == evento.idEvento).toList().forEach((y) => columnContent.add(ListTilePrevendita(prevendita: y)));

    return columnContent;
  }

  List<Evento> getEventi(){
    for(int i = 0; i < prevendite.length; i++) {
      bool found = false;
      for(int j = 0; j < eventi.length; j++){
        if(prevendite[i].fkEvento.idEvento == eventi[j].idEvento)
          found = true;
      }

      if(!found)
        eventi.add(prevendite[i].fkEvento);
    }

    return eventi;
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(groupByValue.nome, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
        Text(new DateFormat("dd/MM/yyyy").format(groupByValue.data), style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)),
      ],
    );
  }
}