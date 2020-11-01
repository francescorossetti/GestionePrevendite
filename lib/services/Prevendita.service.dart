import 'package:gestioneprevendite/config/database.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';

class PrevenditaService {
  static const tableName = "Prevendita";
  
  Future<List<Prevendita>> getPrevendite() async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM Prevendita p INNER JOIN Evento e ON e.IDEvento = p.FK_EventoPrevendita LEFT JOIN SottoPR sp ON sp.IDSottoPR = p.VendutaDa WHERE PrevenditaAbilitata = 1");

      List<Prevendita> list = res.isNotEmpty ? res.map((c) => Prevendita.fromMap(c)).toList() : [];
      return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<List<Prevendita>> getPrevenditeByEvento(int evento) async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM Prevendita p INNER JOIN Evento e ON e.IDEvento = p.FK_EventoPrevendita LEFT JOIN SottoPR sp ON sp.IDSottoPR = p.VendutaDa WHERE IDEvento = ? AND PrevenditaAbilitata = 1", [ evento ]);

      List<Prevendita> list = res.isNotEmpty ? res.map((c) => Prevendita.fromMap(c)).toList() : [];
      return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPrevendit4Isto() async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT e.DataEvento as Data, COUNT(*) AS Vendite FROM Prevendita p INNER JOIN Evento e ON e.IDEvento = p.FK_EventoPrevendita WHERE e.DataEvento >= DATE('now') AND PrevenditaAbilitata = 1 GROUP BY e.DataEvento");

      return res.isNotEmpty ? res : [];
    }
    catch(ex) {
      return [];
    }
  }

    Future<List<Map<String, dynamic>>> getPrevendit4Pie() async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT a.NomeAzienda as Azienda, (SUM(p.CostoPrevendita)) * (a.AziendaPercentuale / 100.0) AS Vendite FROM Prevendita p INNER JOIN Evento e ON e.IDEvento = p.FK_EventoPrevendita INNER JOIN Azienda a ON a.IDAzienda = e.FK_LocaleEvento WHERE PrevenditaAbilitata = 1 GROUP BY a.NomeAzienda");

      return res.isNotEmpty ? res : [];
    }
    catch(ex) {
      return [];
    }
  }

  Future<bool> insert(List<Prevendita> prevendite) async {
    try {
      final db = await DBProvider().database;
      
      int result = 0;
      
      for(int i = 0 ; i < prevendite.length ; i++){
        result += await db.insert(tableName, prevendite[i].toMap());
      }

      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }
  
  Future<bool> update(Prevendita prevendita) async {
    try {
      final db = await DBProvider().database;
      int result = await db.update(tableName, prevendita.toMap(), where: "IDPrevendita = ?", whereArgs: [ prevendita.idPrevendita ]);
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> delete(Prevendita prevendita) async {
    try {
      return update(prevendita);
    }
    catch(ex) {
      return false;
    }
  }
}