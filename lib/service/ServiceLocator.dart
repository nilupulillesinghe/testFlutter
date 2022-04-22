import 'package:get_it/get_it.dart';
import 'package:test_flutter/service/Impl/DatabaseServiceImpl.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(DatabaseServiceImpl());
}