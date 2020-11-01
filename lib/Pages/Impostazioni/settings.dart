import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Utils/PDFProvider.dart';
import 'package:gestioneprevendite/UIModels/AppBar.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:path/path.dart';

class Impostazioni extends StatefulWidget {
  @override
  _ImpostazioniState createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<Impostazioni> {
  void loadFile() async {
    var dir = await PDFProvider.getPath();
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['db']
    );

    if(file != null)
      await file.copy(join(dir.path, "GestionePrevendite.db"));
  }

  @override
  Widget build(BuildContext context) {
    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
    }
    
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context).translate("impostazioni"), widgets: <Widget>[]),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async { 
                  String file = await PDFProvider.getDB();
                  PDFProvider.shareFile("Database", file);
                },
                child: new Text(AppLocalizations.of(context).translate("esporta_database"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: loadFile,
                child: new Text(AppLocalizations.of(context).translate("importa_database"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 30),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async { 
                  String file = await PDFProvider.pdfAziende(context);
                  PDFProvider.shareFile(AppLocalizations.of(context).translate("aziende"), file);
                },
                child: new Text(AppLocalizations.of(context).translate("esporta_aziende"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async { 
                  String file = await PDFProvider.pdfSottoPR(context);
                  PDFProvider.shareFile(AppLocalizations.of(context).translate("personale"), file);
                },
                child: new Text(AppLocalizations.of(context).translate("esporta_personale"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async { 
                  String file = await PDFProvider.pdfEventi(context);
                  PDFProvider.shareFile(AppLocalizations.of(context).translate("eventi"), file);
                },
                child: new Text(AppLocalizations.of(context).translate("esporta_eventi"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child:SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () async { 
                  String file = await PDFProvider.pdfPrevendite(context);
                  PDFProvider.shareFile(AppLocalizations.of(context).translate("prevendite"), file);
                },
                child: new Text(AppLocalizations.of(context).translate("esporta_prevendite"), style: TextStyle(fontSize: 20)),
              )
            )
          ),
          SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: SizedBox(
              width: double.infinity, // match_parent
              height: 40,
              child: Container(color: Colors.blue, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Text(AppLocalizations.of(context).translate("moda_scura"), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white)),
                Switch(value: Theme.of(context).brightness == Brightness.dark, onChanged: (val) => changeBrightness())
              ])
            ))
          ),
        ],
      )
    );
  }
}