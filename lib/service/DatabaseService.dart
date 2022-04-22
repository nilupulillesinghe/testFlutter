import 'package:test_flutter/models/UserModel.dart';

abstract class DatabaseService{
  Future<bool> saveUserDetails(UserModel userModel);
  Future<bool> checkUsername(UserModel userModel);
  Future<bool> loginValidate(UserModel userModel);
}