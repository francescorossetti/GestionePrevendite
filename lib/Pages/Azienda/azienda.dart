import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Azienda/ListTileAzienda.dart';
import 'package:gestioneprevendite/Pages/Azienda/aziendaDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/PDFProvider.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/Pages/Utils/emptyList.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/services/Azienda.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class AziendaList extends StatefulWidget {
  @override
  _AziendaListState createState() => _AziendaListState();
}

class _AziendaListState extends State<AziendaList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () async { 
            String file = await PDFProvider.pdfAziende(context);
            PDFProvider.shareFile(AppLocalizations.of(context).translate("aziende"), file);
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              EnterExitRoute(exitPage: AziendaList(), enterPage: AziendaDetail(azienda: null))
            );  
          },
        )
      ]),
      bottomNavigationBar: MyNavigationBar(),
      body: FutureBuilder(
        future: new AziendaService().getAziende(),
        builder: (BuildContext context, AsyncSnapshot<List<Azienda>> snapshot) {
          if(snapshot.hasData){
            return snapshot.data.length > 0 ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTileAzienda(azienda: snapshot.data[index]);
              }
            ) : EmptyListPlaceHolder(title: AppLocalizations.of(context).translate("nessuna_azienda"), descrizione: AppLocalizations.of(context).translate("nessuna_azienda_desc"), image:  AssetImage('assets/images/aziende_add.png'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}