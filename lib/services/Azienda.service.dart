import 'package:gestioneprevendite/config/database.dart';
import 'package:gestioneprevendite/models/Azienda.model.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/services/Evento.service.dart';

class AziendaService {
  static const tableName = "Azienda";

  Future<List<Azienda>> getAziende() async {
    try {
    final db = await DBProvider().database;
    var res = await db.query(tableName, where: "AziendaAbilitato = 1");

    List<Azienda> list = res.isNotEmpty ? res.map((c) => Azienda.fromMap(c)).toList() : [];
    return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<List<Azienda>> getAziendaByID(int id) async {
    try {
    final db = await DBProvider().database;
    var res = await db.query(tableName, where: "IDAzienda = ?", whereArgs: [ id ]);

    List<Azienda> list = res.isNotEmpty ? res.map((c) => Azienda.fromMap(c)).toList() : [];
    return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<bool> deleteAllEventiByAzienda(Azienda azienda) async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM " + tableName + " a INNER JOIN Evento e ON a.IDAzienda = e.FK_LocaleEvento WHERE IDAzienda = ?", [ azienda.idAzienda ]);

      List<Evento> list = res.isNotEmpty ? res.map((c) => Evento.fromMap(c)).toList() : [];
      list.forEach((x) { x.ablitato = false; EventoService().delete(x); });

      return true;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> insert(Azienda azienda) async {
    try {
      final db = await DBProvider().database;
      int result = await db.insert(tableName, azienda.toMap());
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> update(Azienda azienda) async {
    try {
      final db = await DBProvider().database;
      int result = await db.update(tableName, azienda.toMap(), where: "IDAzienda = ?", whereArgs: [ azienda.idAzienda ]);
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> delete(Azienda azienda) async {
    try {
      await deleteAllEventiByAzienda(azienda);
      return update(azienda);
    }
    catch(ex) {
      return false;
    }
  }
}