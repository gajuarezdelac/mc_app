import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
export 'package:mc_app/src/models/welding_control_model.dart';
import 'package:mc_app/src/data/database_schema.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class DBContext {
  static Database _database;
  static final DBContext db = DBContext._();
  static final DBContext _instance = new DBContext.internal(); // G
  factory DBContext() => _instance; // G
  static bool dbExists = false;
  DBContext._();
  DBContext.internal(); // G

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  // Método asíncrono para la creación de la BD y las tablas
  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "SpectrumCalidad.db");
    var exists = await databaseExists(path);

    //Si no existe la bdd se hace una copia de assets
    if (!exists) {
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "SpectrumCalidad.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
      //print('write: '+path);
    }

    //Se crea la tabla Junta
    return await openDatabase(path, version: 1, onOpen: (db) {
      print(path);
    }, onCreate: (Database db, int version) async {
      if (!exists) {
        //Se crean las tablas
        initScript.forEach((script) async => await db.execute(script));
        //Se importan los datos de los Temp a las tablas reales
        //importScript.forEach((script) async => await db.execute(script));
        //print('Tablas creadas');
      }
    });
  }

  executeRawQuery(String rawQuery) async {
    final db = await database;
    final res = db.execute(rawQuery);

    return res;
  }

  Future<Map<String, String>> getColumnsInfo(String tableName) async {
    final db = await database;
    /*var res = await db
        .rawQuery("SELECT * FROM pragma_table_info('" + tableName + "');");*/
    List<Map<String, dynamic>> res = await db.rawQuery(
        "SELECT sql FROM sqlite_master WHERE type='table' AND name='" +
            tableName +
            "';");

    List<String> lista = res.isNotEmpty
        ? res.first
            .toString()
            .replaceAll(
                " (strftime('%Y-%m-%d %H:%M:%f', datetime('now', 'localtime')))",
                "")
            .split(',')
        : [];

    Map<String, String> mapCols = new Map();

    lista.forEach((element) {
      List<String> parts = [];
      if (!element.contains('FOREIGN KEY(') &&
          !element.contains('PRIMARY KEY(')) {
        if (element.contains('CREATE')) {
          parts = element.trim().split('(')[1].trim().split('\"');
        } else
          parts = element.trim().split('\"');

        if (!mapCols.containsKey(parts[1].trim()))
          mapCols.addAll({
            parts[1].trim():
                parts[2].trim().replaceAll('  ', ' ').split(' ')[0].trim()
          });
      }
    });

    return mapCols;
  }

  Future<List<Map<String, dynamic>>> getTableNameList() async {
    final db = await database;
    var res = await db
        .rawQuery("SELECT m.name FROM sqlite_master m WHERE m.type='table'");

    return res;
  }

  Future<List<Map<String, dynamic>>> executeQuery(String rawQuery) async {
    final db = await database;
    final res = db.rawQuery(rawQuery);

    return res;
  }

  closeDB() async {
    _database.close();
    _database = null;
  }

  Future<bool> existsColumnInTable(String tableName, String colName) async {
    final db = await database;
    /*var res = await db.rawQuery("SELECT * FROM pragma_table_info('" +
        tableName +
        "') WHERE name='" +
        colName +
        "';");*/
    var res = await db.rawQuery(
        "SELECT * FROM sqlite_master WHERE type='table' AND name='" +
            tableName +
            "' AND sql LIKE '%" +
            colName +
            "%';");

    bool exists = res.isNotEmpty ? true : false;

    return exists;
  }
}
