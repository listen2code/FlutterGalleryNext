import 'package:flutter_gallery_next/base/common/database_manager.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:package_libs/utils/logger_util.dart';

class UserInfoDataBase {
  static const String tag = "UserInfoDataBase";
  static const int _dbVersion = 1;
  static const String _dbPathName = "$tag.db";
  static const String _tableName = "UserInfo";

  static String createTableSQL = "CREATE TABLE IF NOT EXISTS $_tableName ("
      "userId INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT,"
      "age TEXT,"
      "address TEXT,"
      "phone TEXT,"
      "email TEXT,"
      "timestamp INTEGER"
      ");";

  static create() async {
    return await DatabaseManager.instance().createTable(
      _dbPathName,
      [createTableSQL],
      dbVersion: _dbVersion,
    );
  }

  static Future<int> save(UserInfoEntity userInfo) async {
    var db = await create();
    Map<String, dynamic> map = userInfo.toJson();
    map["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    log("$tag save: $map");
    return DatabaseManager.instance().saveObject(db, map, tableName: _tableName);
  }

  static Future<UserInfoEntity?> getByUserId(String userId) async {
    return get(condition: "userId = ?", values: [userId]);
  }

  static Future<UserInfoEntity?> get({String? condition, List<dynamic>? values}) async {
    var db = await create();
    var res = await DatabaseManager.instance().getObject(
      db,
      tableName: _tableName,
      whereId: condition,
      whereArgs: values,
    );
    if (res.isNotEmpty) {
      Map<String, dynamic>? map = res.first;
      log("$tag get: $map");
      return UserInfoEntity.fromJson(map);
    } else {
      return null;
    }
  }

  static Future<List<UserInfoEntity>> getList() async {
    var db = await create();
    List<Map<String, dynamic>> list = await DatabaseManager.instance().getObjectList(
      db,
      tableName: _tableName,
    );
    log("$tag getList: $list");
    if (list.isNotEmpty) {
      return list.map((e) {
        return UserInfoEntity.fromJson(e);
      }).toList();
    }
    return [];
  }

  static Future<int> updateLast(UserInfoEntity userInfo) async {
    return update(userInfo, condition: "userId = (SELECT MAX(userId) FROM $_tableName)");
  }

  static Future<int> update(UserInfoEntity userInfo, {String? condition, List<dynamic>? values}) async {
    log("$tag update: $condition");
    var db = await create();
    Map<String, dynamic> map = userInfo.toJson();
    map["timestamp"] = DateTime.now().millisecondsSinceEpoch;

    return DatabaseManager.instance().updateObject(
      db,
      map,
      tableName: _tableName,
      whereId: condition,
      whereArgs: values,
    );
  }

  static Future<int> deleteLast() async {
    return delete(condition: "userId = (SELECT MAX(userId) FROM $_tableName)");
  }

  static Future<int> deleteByUserId(String userId) async {
    return delete(condition: "userId = ?", values: [userId]);
  }

  static Future<int> delete({String? condition, List<dynamic>? values}) async {
    log("$tag delete: $condition");
    var db = await create();
    return DatabaseManager.instance().deleteObject(
      db,
      tableName: _tableName,
      whereId: condition,
      whereArgId: values,
    );
  }

  static Future<void> closeDataBase() async {
    var db = await create();
    await DatabaseManager.instance().closeDB(db);
  }
}
