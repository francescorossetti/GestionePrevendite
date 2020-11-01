import 'package:gestioneprevendite/config/database.dart';
import 'package:gestioneprevendite/models/Evento.model.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';

class EventoService {
  static const tableName = "Evento";

  Future<List<Evento>> getEventi() async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM " + tableName + " e INNER JOIN Azienda a ON a.IDAzienda = e.FK_LocaleEvento WHERE EventoAbilitato == 1 AND AziendaAbilitato = 1");

      List<Evento> list = res.isNotEmpty ? res.map((c) => Evento.fromMap(c)).toList() : [];
      return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<bool> deleteAllPrevenditeByEvento(Evento evento) async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM " + tableName + " e INNER JOIN Prevendita p ON e.IDEvento = p.FK_EventoPrevendita WHERE IDEvento = ?", [ evento.idEvento ]);

      List<Prevendita> list = res.isNotEmpty ? res.map((c) => Prevendita.fromMap(c)).toList() : [];
      list.forEach((x) { x.ablitato = false; PrevenditaService().delete(x); });

      return true;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> insert(Evento evento) async {
    try {
      final db = await DBProvider().database;
      int result = await db.insert(tableName, evento.toMap());
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }
  
  Future<bool> update(Evento evento) async {
    try {
      final db = await DBProvider().database;
      int result = await db.update(tableName, evento.toMap(), where: "IDEvento = ?", whereArgs: [ evento.idEvento ]);
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> delete(Evento evento) async {
    try {
      await deleteAllPrevenditeByEvento(evento);
      return update(evento);
    }
    catch(ex) {
      return false;
    }
  }
}