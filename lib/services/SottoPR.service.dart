import 'package:gestioneprevendite/config/database.dart';
import 'package:gestioneprevendite/models/Prevendita.model.dart';
import 'package:gestioneprevendite/models/SottoPR.model.dart';
import 'package:gestioneprevendite/services/Prevendita.service.dart';

class SottoPRService {
  static const tableName = "SottoPR";

  Future<List<SottoPR>> getSottoPR() async {
    try {
      final db = await DBProvider().database;
      var res = await db.query(tableName, where: "SottoPRAbilitato = 1");

      List<SottoPR> list = res.isNotEmpty ? res.map((c) => SottoPR.fromMap(c)).toList() : [];
      return list;
    }
    catch(ex) {
      return [];
    }
  }

  Future<bool> deleteAllPrevenditeBySottoPR(SottoPR sottoPR) async {
    try {
      final db = await DBProvider().database;
      var res = await db.rawQuery("SELECT * FROM " + tableName + " sp INNER JOIN Prevendita p ON sp.IDSottoPR = p.VendutaDa INNER JOIN Evento e ON e.IDEvento = p.FK_EventoPrevendita WHERE IDSottoPR = ?", [ sottoPR.idSottoPr ]);

      List<Prevendita> list = res.isNotEmpty ? res.map((c) => Prevendita.fromMap(c)).toList() : [];
      list.forEach((x) { x.ablitato = false; PrevenditaService().delete(x); });

      return true;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> insert(SottoPR sottoPR) async {
    try {
      final db = await DBProvider().database;
      int result = await db.insert(tableName, sottoPR.toMap());
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> update(SottoPR sottoPR) async {
    try {
      final db = await DBProvider().database;
      int result = await db.update(tableName, sottoPR.toMap(), where: "IDSottoPR = ?", whereArgs: [ sottoPR.idSottoPr ]);
      return result > 0;
    }
    catch(ex) {
      return false;
    }
  }

  Future<bool> delete(SottoPR sottoPR) async {
    try {
      await deleteAllPrevenditeBySottoPR(sottoPR);
      return update(sottoPR);
    }
    catch(ex) {
      return false;
    }
  }
}