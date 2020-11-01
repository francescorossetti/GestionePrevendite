import 'package:meta/meta.dart';
import 'dart:convert';

Azienda aziendaFromJson(Map<String, dynamic> json) => Azienda.fromMap(json);

String aziendaToJson(Azienda data) => json.encode(data.toMap());

class Azienda {
  int idAzienda;
  int percentuale;
  bool ablitato;
  String nome;

  Azienda({
    @required this.idAzienda,
    @required this.nome,
    @required this.percentuale,
    @required this.ablitato
  });

  factory Azienda.fromMap(Map<String, dynamic> json) => Azienda(
    idAzienda: json["IDAzienda"],
    nome: json["NomeAzienda"],
    percentuale: json['AziendaPercentuale'],
    ablitato: json['AziendaAbilitato'] == 1 ? true : false
  );

  Map<String, dynamic> toMap() => this.idAzienda != null ? {
    "IDAzienda": idAzienda,
    "NomeAzienda": nome,
    "AziendaPercentuale": percentuale,
    "AziendaAbilitato": ablitato ? 1 : 0
  } : { 
    "NomeAzienda": nome,
    "AziendaPercentuale": percentuale,
    "AziendaAbilitato": ablitato ? 1 : 0
  };
}
/*
await db.execute("CREATE TABLE \"Azienda\" ("
"\"IDAzienda\" INTEGER NOT NULL,"
"\"NomeAzienda\" VARCHAR(100) NOT NULL UNIQUE,"
"\"AziendaPercentuale\" INTEGER NOT NULL,"
"\"AziendaAbilitato\" BIT NOT NULL DEFAULT 1,"
"PRIMARY KEY(\"IDAzienda\")"
");");
*/