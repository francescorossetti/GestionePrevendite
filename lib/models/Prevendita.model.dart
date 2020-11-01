import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Prevendita prevenditaFromJson(Map<String, dynamic> json) => Prevendita.fromMap(json);

String prevenditaToJson(Prevendita data) => json.encode(data.toMap());

class Prevendita {
  int idPrevendita;
  Evento fkEvento;
  double costoPrevendita;
  String note;
  SottoPR vendutaDa;
  bool ablitato;

  Prevendita({
    @required this.idPrevendita,
    @required this.fkEvento,
    @required this.costoPrevendita,
    @required this.ablitato,
    this.note,
    this.vendutaDa,
  });

  factory Prevendita.fromMap(Map<String, dynamic> json) => Prevendita(
    idPrevendita: json["IDPrevendita"],
    fkEvento: new Evento(idEvento: json["FK_EventoPrevendita"], nome: json["NomeEvento"], data: DateTime.parse(json["DataEvento"]), costoPrevendite: json["CostoPrevenditeEvento"].toDouble(), ablitato: json['EventoAbilitato'] == 1 ? true : false, fkLocale: null),
    costoPrevendita: json["CostoPrevendita"].toDouble(),
    note: json['NotePrevendita'],
    vendutaDa: json["VendutaDa"] != null ? new SottoPR(idSottoPr: json["VendutaDa"], nome: json["NomeSottoPR"], ablitato: json["SottoPRAbilitato"] == 0 ? false : true) : null,
    ablitato: json['PrevenditaAbilitata'] == 1 ? true : false
  );

  Map<String, dynamic> toMap() => idPrevendita != null ? {
    "IDPrevendita": idPrevendita,
    "FK_EventoPrevendita": fkEvento.idEvento,
    "CostoPrevendita": costoPrevendita,
    "NotePrevendita": note,
    "VendutaDa": vendutaDa != null ? vendutaDa.idSottoPr : null,
    "PrevenditaAbilitata": ablitato ? 1 : 0
  } : {
    "FK_EventoPrevendita": fkEvento.idEvento,
    "CostoPrevendita": costoPrevendita,
    "NotePrevendita": note,
    "VendutaDa": vendutaDa != null ? vendutaDa.idSottoPr : null,
    "PrevenditaAbilitata": ablitato ? 1 : 0
  };
}

/*
await db.execute("CREATE TABLE \"Prevendita\" ("
"\"IDPrevendita\"	INTEGER NOT NULL UNIQUE,"
"\"FK_EventoPrevendita\"	INTEGER NOT NULL,"
"\"CostoPrevendita\"	NUMERIC NOT NULL,"
"\"NotePrevendita\" TEXT,"
"\"PrevenditaAbilitata\" BIT NOT NULL DEFAULT 1,"
"\"VendutaDa\"	INTEGER,"
"PRIMARY KEY(\"IDPrevendita\"),"
"FOREIGN KEY(\"FK_EventoPrevendita\") REFERENCES \"Evento\"(\"IDEvento\") ON UPDATE NO ACTION ON DELETE CASCADE,"
"FOREIGN KEY(\"VendutaDa\") REFERENCES \"SottoPR\"(\"IDSottoPR\") ON UPDATE NO ACTION ON DELETE CASCADE"
");");
*/