import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_flutter/models/UserModel.dart';
import 'package:test_flutter/service/DatabaseService.dart';
import 'package:path/path.dart';

class DatabaseServiceImpl implements DatabaseService {
  Database? _db = null;
  String dbPath = "";
  String path = "";

  DatabaseServiceImpl() {
    // callFunc();
    // init();
  }

  /// Initiating db connection.
  Future init() async {
    dbPath = (await getDatabasesPath())!;
    path = join(dbPath, "test.db");

    final exist = await databaseExists(path);

    if (exist) {
      _db = await openDatabase(path);
      print("dn exists");
    } else {
      print("new");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        throw Exception(e);
      }
      ByteData data = await rootBundle.load(join("assets/db", "test.db"));
      List<int> bytes = data.buffer
          .asUint8ClampedList(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

      print("db copied");
    }
  }

  /// Save user details to db.
  @override
  Future<bool> saveUserDetails(UserModel userModel) async {
    try {
      await init();

      await _db!.transaction((txn) async {
        await txn.insert("test_user", userModel.toMap());
      });
    } catch (e) {
      print("Exception");
      print(e);
      throw Exception(e);
    }
    print("true");
    return true;
  }

  /// Check username or email exist in db.
  @override
  Future<bool> checkUsername(UserModel userModel) async {
    List<UserModel> list = [];
    try {
      await init();

      await _db!.transaction((txn) async {
        List<Map<String, dynamic>> results = await txn.rawQuery("SELECT * " +
            " FROM test_user " +
            " WHERE test_user_user_name ='" +
            userModel.test_user_user_name +
            "'" +
            " OR test_user_email ='" +
            userModel.test_user_email +
            "' ");

        results.forEach((result) {
          UserModel userModel = UserModel.fromMap(result);
          list.add(userModel);
        });
      });

      if (list != null && list.length > 0) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print("Exception");
      print(e);
      throw Exception(e);
    }
  }

  /// Validate user from db using username and password.
  @override
  Future<bool> loginValidate(UserModel userModel) async {
    List<UserModel> list = [];
    try {
      await init();

      await _db!.transaction((txn) async {
        List<Map<String, dynamic>> results = await txn.rawQuery("SELECT * " +
            " FROM test_user " +
            " WHERE test_user_user_name ='" +
            userModel.test_user_user_name +
            "'" +
            " AND test_user_password ='" +
            userModel.test_user_password +
            "' ");

        results.forEach((result) {
          UserModel userModel = UserModel.fromMap(result);
          list.add(userModel);
        });
      });

      if (list != null && list.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Exception");
      print(e);
      throw Exception(e);
    }
  }
}
