import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Utils/PDFProvider.dart';
import 'package:gestioneprevendite/Pages/SottoPR/ListTileSottoPR.dart';
import 'package:gestioneprevendite/Pages/SottoPR/sottoprDetail.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/Pages/Utils/emptyList.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/UIModels/NavigationBar.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:gestioneprevendite/services/SottoPR.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';

class SottoPRList extends StatefulWidget {
  @override
  _SottoPRListState createState() => _SottoPRListState();
}

class _SottoPRListState extends State<SottoPRList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("app_name"), widgets: <Widget>[
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () async { 
            String file = await PDFProvider.pdfSottoPR(context);
            PDFProvider.shareFile(AppLocalizations.of(context).translate("personale"), file);
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              EnterExitRoute(exitPage: SottoPRList(), enterPage: SottoPRDetail(sottoPR: null))
            );
          },
        )
      ]),
      bottomNavigationBar: MyNavigationBar(),
      body: FutureBuilder(
        future: new SottoPRService().getSottoPR(),
        builder: (BuildContext context, AsyncSnapshot<List<SottoPR>> snapshot) {
          if(snapshot.hasData){
            return snapshot.data.length > 0 ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTileSottoPR(sottoPR: snapshot.data[index]);
              }
            ) : EmptyListPlaceHolder(title: AppLocalizations.of(context).translate("nessun_personale"), descrizione: AppLocalizations.of(context).translate("nessun_personale_desc"), image:  AssetImage('assets/images/staff_add.png'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}