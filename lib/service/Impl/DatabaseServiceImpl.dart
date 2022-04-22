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

  Future init() async {
    dbPath = (await getDatabasesPath())!;
    path = join(dbPath, "test.db");

    final exist = await databaseExists(path);

    if (exist) {
      _db = await openDatabase(path);
      print("dn exists");
      // ByteData data = await rootBundle.load(join(dbPath,"upKeep.db"));
      // List<int> bytes = data.buffer.asUint8ClampedList(data.offsetInBytes,data.lengthInBytes);
      //
      // String newpath = await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS);
      // await File(newpath).writeAsBytes(bytes,flush: true);
    } else {
      print("new");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets/db", "test.db"));
      List<int> bytes = data.buffer
          .asUint8ClampedList(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);

      print("db copied");
    }
  }

  @override
  Future<bool> saveUserDetails(UserModel userModel) async {
    try {
      await init();

      await _db!.transaction((txn) async {
        await txn.insert("test_user", userModel.toMap());
      });
    } catch (Exception) {
      print("Exception");
      print(Exception);
      return false;
    }
    print("true");
    return true;
  }

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
    } catch (Exception) {
      print("Exception");
      print(Exception);
      return false;
    }
  }

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
          print(userModel.test_user_password);
          print(userModel.test_user_email);
          print(userModel.test_user_user_name);
        });
      });

      if (list != null && list.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (Exception) {
      print("Exception");
      print(Exception);
      return false;
    }
  }
}
