import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:gestioneprevendite/services/Azienda.service.dart';
import 'package:gestioneprevendite/services/Evento.service.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';
import 'package:gestioneprevendite/services/SottoPR.service.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFProvider {
  static Future<void> shareFile(String name, String path) async {
    if(path != null) 
      await FlutterShare.shareFile(
        title: name,
        text: 'Gestione Prevendite ' + name,
        filePath: path,
      );
  }

  static pw.Document initDocument() {
    final pdf = pw.Document(deflate: zlib.encode);

    return pdf;
  }

  static Future<Directory> getPath() async {
    Directory documentsDirectory;
    if(Platform.isAndroid)
      documentsDirectory = await getExternalStorageDirectory();
    else if(Platform.isIOS)
      documentsDirectory = await getApplicationDocumentsDirectory();

    return documentsDirectory;
  }

  static Future<String> getDB() async {
    Directory path = await getPath();

    return join(path.path, "GestionePrevendite.db");
  }

  static Future<String> pdfAziende(BuildContext context) async {
    List<Azienda> aziende = await AziendaService().getAziende();

    if(aziende.length > 0) {
      final pdf = initDocument();

      String nomeModulo = AppLocalizations.of(context).translate("aziende");
    
      pdf.addPage(pw.MultiPage(build: (c) =>[
        pw.Center(child: pw.Text(nomeModulo, style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold))),
        pw.Text("\n\n\n"),
        pw.Table.fromTextArray(context: c, data: <List<String>> [
          <String>[AppLocalizations.of(context).translate("nome"), AppLocalizations.of(context).translate("percentuale_compenso")],
          ...aziende.map((item) => [item.nome, item.percentuale.toString() + "%"])
        ])
      ]));    

      String dir = (await getPath()).path;
      dir = "$dir/output";

      String path = "$dir/$nomeModulo" + "_" + DateTime.now().toString() + ".pdf";
      File file = File(path);

      var dir2check = Directory(dir);

      bool dirExists = await dir2check.exists();
      if(!dirExists){
        await dir2check.create();
      }

      await file.writeAsBytes(pdf.save());

      return path;
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("nessuna_azienda") + "\n" + AppLocalizations.of(context).translate("nessuna_azienda_desc"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
      );

      return null;
    }
  }

  static Future<String> pdfSottoPR(BuildContext context) async {
    List<SottoPR> sottoPR = await SottoPRService().getSottoPR();

    if(sottoPR.length > 0) {
      final pdf = initDocument();
    
      String nomeModulo = AppLocalizations.of(context).translate("personale");

      pdf.addPage(pw.MultiPage(build: (c) =>[
        pw.Center(child: pw.Text(nomeModulo, style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold))),
        pw.Text("\n\n\n"),
        pw.Table.fromTextArray(context: c, data: <List<String>> [
          <String>[AppLocalizations.of(context).translate("nome")],
          ...sottoPR.map((item) => [item.nome])
        ])
      ]));    

      String dir = (await getPath()).path;
      dir = "$dir/output";

      String path = "$dir/$nomeModulo" + "_" + DateTime.now().toString() + ".pdf";
      File file = File(path);

      var dir2check = Directory(dir);

      bool dirExists = await dir2check.exists();
      if(!dirExists){
        await dir2check.create();
      }

      await file.writeAsBytes(pdf.save());

      return path;
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("nessun_personale") + "\n" + AppLocalizations.of(context).translate("nessun_personale_desc"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
      );

      return null;
    }
  }

  static Future<String> pdfEventi(BuildContext context) async {
    List<Evento> eventi = await EventoService().getEventi();

    if(eventi.length > 0) {
      final pdf = initDocument();
    
      String nomeModulo = AppLocalizations.of(context).translate("eventi");

      pdf.addPage(pw.MultiPage(build: (c) =>[
        pw.Center(child: pw.Text(nomeModulo, style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold))),
        pw.Text("\n\n\n"),
        pw.Table.fromTextArray(context: c, data: <List<String>> [
          <String>[AppLocalizations.of(context).translate("nome"), AppLocalizations.of(context).translate("data_evento"), AppLocalizations.of(context).translate("nome_azienda"), AppLocalizations.of(context).translate("prezzo_prevendita")],
          ...eventi.map((item) => [item.nome, new DateFormat("dd/MM/yyyy").format(item.data), item.fkLocale.nome, item.costoPrevendite.toString()])
        ])
      ]));    

      String dir = (await getPath()).path;
      dir = "$dir/output";

      String path = "$dir/$nomeModulo" + "_" + DateTime.now().toString() + ".pdf";
      File file = File(path);

      var dir2check = Directory(dir);

      bool dirExists = await dir2check.exists();
      if(!dirExists){
        await dir2check.create();
      }

      await file.writeAsBytes(pdf.save());

      return path;
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("nessun_evento") + "\n" + AppLocalizations.of(context).translate("nessun_evento_desc"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
      );

      return null;
    }
  }

  static Future<String> pdfPrevendite(BuildContext context, [ Evento evento ]) async {
    List<Prevendita> prevendite = new List<Prevendita>();

    if(prevendite.length > 0) {
      if(evento != null)
        prevendite = await PrevenditaService().getPrevenditeByEvento(evento.idEvento);
      else
        prevendite = await PrevenditaService().getPrevendite();

      final pdf = initDocument();
    
      String nomeModulo = "";
      
      if(evento != null)
        nomeModulo = AppLocalizations.of(context).translate("prevendite") + " " + evento.nome;
      else 
        nomeModulo = AppLocalizations.of(context).translate("prevendite");

      pdf.addPage(pw.MultiPage(build: (c) =>[
        pw.Center(child: pw.Text(nomeModulo, style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold))),
        pw.Text("\n\n\n"),
        pw.Table.fromTextArray(context: c, data: <List<String>> [
          <String>[AppLocalizations.of(context).translate("numero_prevendita_export"), AppLocalizations.of(context).translate("nome_evento"), AppLocalizations.of(context).translate("prezzo_export"), AppLocalizations.of(context).translate("venduta_da_export"), AppLocalizations.of(context).translate("note")],
          ...prevendite.map((item) => [item.idPrevendita.toString(), item.fkEvento.nome, item.costoPrevendita.toString(), (item.vendutaDa == null ? "" : item.vendutaDa.nome), item.note != null ? item.note : ""])
        ])
      ]));    

      String dir = (await getPath()).path;
      dir = "$dir/output";

      String path = "$dir/$nomeModulo" + "_" + DateTime.now().toString() + ".pdf";
      File file = File(path);

      var dir2check = Directory(dir);

      bool dirExists = await dir2check.exists();
      if(!dirExists){
        await dir2check.create();
      }

      await file.writeAsBytes(pdf.save());

      return path;
    } else {
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate("nessuna_prevendita") + "\n" + AppLocalizations.of(context).translate("nessuna_prevendita_desc"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
      );

      return null;
    }
  }
}