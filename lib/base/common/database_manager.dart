import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._private();

  factory DatabaseManager.instance() => _instance;
  static final DatabaseManager _instance = DatabaseManager._private();

  Future<Database?> createTable(
    String dbPathName,
    List<String> createSQLList, {
    List<String>? deleteSQLList,
    List<String>? alterSQLList,
    int? dbVersion,
  }) async {
    var databasePath = await getDatabasesPath();
    String path = databasePath + dbPathName;
    if (!databasePath.endsWith('/')) {
      path = "$databasePath/$dbPathName";
    }
    return openDatabase(path, version: dbVersion, onUpgrade: (db, oldVersion, newVersion) async {
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

  Future<int> saveObject(Database db, Map<String, dynamic> json, {required String tableName}) {
    return db.insert(tableName, json);
  }

  Future<List<Map<String, Object?>>> getObject(
    Database db, {
    required String tableName,
    String? whereId,
    List<Object?>? whereArgs,
  }) {
    return db.query(tableName, where: whereId, whereArgs: whereArgs);
  }

  Future<int> updateObject(
    Database db,
    Map<String, dynamic> json, {
    required String tableName,
    required String? whereId,
    required List<Object?>? whereArgs,
  }) {
    return db.update(tableName, json, where: whereId, whereArgs: whereArgs);
  }

  Future<int> deleteObject(
    Database db, {
    required String tableName,
    String? whereId,
    List<Object?>? whereArgId,
  }) {
    return db.delete(tableName, where: whereId, whereArgs: whereArgId);
  }

  Future<List<Map<String, dynamic>>> getObjectList(Database db, {required String tableName}) {
    return db.query(tableName);
  }

  Future<void> closeDB(Database db) async {
    await db.close();
  }
}
