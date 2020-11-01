import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  createDatabase(Database db, int version) async {
    await db.execute("PRAGMA foreign_keys = ON;");

    await db.execute("CREATE TABLE \"Azienda\" ("
    "\"IDAzienda\" INTEGER NOT NULL,"
    "\"NomeAzienda\" VARCHAR(100) NOT NULL UNIQUE,"
    "\"AziendaPercentuale\" INTEGER NOT NULL,"
    "\"AziendaAbilitato\" BIT NOT NULL DEFAULT 1,"
    "PRIMARY KEY(\"IDAzienda\")"
    ");");

    await db.execute("CREATE TABLE \"SottoPR\" ("
	  "\"IDSottoPR\" INTEGER NOT NULL UNIQUE,"
	  "\"NomeSottoPR\"	VARCHAR(100) NOT NULL,"
    "\"SottoPRAbilitato\" BIT NOT NULL DEFAULT 1,"
    "PRIMARY KEY(\"IDSottoPR\")"
    ");");

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
  }

  initDB() async {
    Directory documentsDirectory;
    if(Platform.isAndroid)
      documentsDirectory = await getExternalStorageDirectory();
    else if(Platform.isIOS)
      documentsDirectory = await getApplicationDocumentsDirectory();
      
    String path = join(documentsDirectory.path, "GestionePrevendite.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: createDatabase, onUpgrade: upgradeDatabase);
  }

  void upgradeDatabase(Database db, int oldVersion, int newVersion) {
    if (oldVersion < newVersion) {
    }
  }
}