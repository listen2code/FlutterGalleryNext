import 'package:sqflite/sqflite.dart';

class DataManager {
  static DataManager? _dbManager;

  static DataManager getInstance() {
    _dbManager ??= DataManager();
    return _dbManager!;
  }

  Future<Database?> createTable(String dbPathName, List<String> createSQLList,
      {List<String>? deleteSQLList,
      List<String>? alterSQLList,
      int? dbVersion}) async {
    var databasePath = await getDatabasesPath();
    String path = databasePath + dbPathName;
    if (!databasePath.endsWith('/')) {
      path = "$databasePath/$dbPathName";
    }
    return openDatabase(path, version: dbVersion,
        onUpgrade: (db, oldVersion, newVersion) async {
      if (deleteSQLList != null && deleteSQLList.isNotEmpty) {
        for (String deleteSQL in deleteSQLList) {
          db.execute(deleteSQL);
        }
        for (String createSQL in createSQLList) {
          db.execute(createSQL);
        }
      }

      if (alterSQLList != null && alterSQLList.isNotEmpty) {
        for (String createSQL in createSQLList) {
          db.execute(createSQL);
        }
        for (String alterSQL in alterSQLList) {
          db.execute(alterSQL);
        }
      }
    }, onCreate: (db, version) async {
      for (String createSQL in createSQLList) {
        db.execute(createSQL);
      }
    });
  }

  Future<int> saveObject(Database db, Map<String, dynamic> json,
      {required String tableName}) {
    var res = db.insert(tableName, json);
    return res;
  }

  Future<List<Map<String, Object?>>> getObject(Database db,
      {required String tableName, String? whereId, List<Object?>? whereArgs}) {
    var res = db.query(tableName, where: whereId, whereArgs: whereArgs);
    return res;
  }

  Future<int> updateObject(Database db, Map<String, dynamic> json,
      {required String tableName,
      required String? whereId,
      required List<Object?>? whereArgs}) {
    var res = db.update(tableName, json, where: whereId, whereArgs: whereArgs);
    return res;
  }

  Future<int> deleteObject(Database db,
      {required String tableName, String? whereId, List<Object?>? whereArgId}) {
    var res = db.delete(tableName, where: whereId, whereArgs: whereArgId);
    return res;
  }

  Future<List<Map<String, dynamic>>> getObjectList(Database db,
      {required String tableName}) {
    var res = db.query(tableName);
    return res;
  }

  void closeDB(Database db) {
    db.close();
  }
}
