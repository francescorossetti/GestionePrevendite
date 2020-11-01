import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Evento eventoFromJson(Map<String, dynamic> json) => Evento.fromMap(json);

String eventoToJson(Evento data) => json.encode(data.toMap());

class Evento {
  int idEvento;
  String nome;
  DateTime data;
  Azienda fkLocale;
  double costoPrevendite;
  bool ablitato;

  Evento({
    @required this.idEvento,
    @required this.nome,
    @required this.data,
    @required this.fkLocale,
    @required this.costoPrevendite,
    @required this.ablitato
  });

  factory Evento.fromMap(Map<String, dynamic> json) => Evento(
    idEvento: json["IDEvento"],
    nome: json["NomeEvento"],
    data: DateTime.parse(json["DataEvento"]),
    fkLocale: new Azienda(idAzienda: json["FK_LocaleEvento"], nome: json['NomeAzienda'], percentuale: json['AziendaPercentuale'], ablitato: json['AziendaAbilitato'] == 1 ? true : false),
    costoPrevendite: json["CostoPrevenditeEvento"].toDouble(),
    ablitato: json['EventoAbilitato'] == 1 ? true : false
  );

  Map<String, dynamic> toMap() => idEvento != null ? {
    "IDEvento": idEvento,
    "NomeEvento": nome,
    "DataEvento": "${data.year.toString().padLeft(4, '0')}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}",
    "FK_LocaleEvento": fkLocale.idAzienda,
    "CostoPrevenditeEvento": costoPrevendite,
    "EventoAbilitato": ablitato ? 1 : 0
  } : {
    "NomeEvento": nome,
    "DataEvento": "${data.year.toString().padLeft(4, '0')}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}",
    "FK_LocaleEvento": fkLocale.idAzienda,
    "CostoPrevenditeEvento": costoPrevendite,
    "EventoAbilitato": ablitato ? 1 : 0
  };
}

/*
await db.execute("CREATE TABLE \"Evento\" ("
"\"IDEvento\"	INTEGER NOT NULL UNIQUE,"
"\"NomeEvento\"	VARCHAR(100) NOT NULL,"
"\"DataEvento\"	DATE NOT NULL,"
"\"CostoPrevenditeEvento\"	NUMERIC NOT NULL,"
"\"EventoAbilitato\" BIT NOT NULL DEFAULT 1,"
"\"FK_LocaleEvento\"	INTEGER NOT NULL,"
"PRIMARY KEY(\"IDEvento\"),"
"FOREIGN KEY(\"FK_LocaleEvento\") REFERENCES \"Azienda\"(\"IDAzienda\") ON UPDATE NO ACTION ON DELETE CASCADE"
");");
*/