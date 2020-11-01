import 'package:meta/meta.dart';
import 'dart:convert';

SottoPR sottoPrFromJson(Map<String, dynamic> json) => SottoPR.fromMap(json);

String sottoPrToJson(SottoPR data) => json.encode(data.toMap());

class SottoPR {
    int idSottoPr;
    String nome;
    bool ablitato;

    SottoPR({
        @required this.idSottoPr,
        @required this.nome,
        @required this.ablitato
    });

    factory SottoPR.fromMap(Map<String, dynamic> json) => SottoPR(
      idSottoPr: json["IDSottoPR"],
      nome: json["NomeSottoPR"],
      ablitato: json["SottoPRAbilitato"] == 1 ? true : false
    );

    Map<String, dynamic> toMap() => idSottoPr != null ? {
      "IDSottoPR": idSottoPr,
      "NomeSottoPR": nome,
      "SottoPRAbilitato": ablitato ? 1 : 0
    } : {
      "NomeSottoPR": nome,
      "SottoPRAbilitato": ablitato ? 1 : 0
    };
}

/*
await db.execute("CREATE TABLE \"SottoPR\" ("
"\"IDSottoPR\" INTEGER NOT NULL UNIQUE,"
"\"NomeSottoPR\"	VARCHAR(100) NOT NULL,"
"\"SottoPRAbilitato\" BIT NOT NULL DEFAULT 1,"
"PRIMARY KEY(\"IDSottoPR\")"
");");
*/