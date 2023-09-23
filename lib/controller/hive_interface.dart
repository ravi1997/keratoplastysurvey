import 'package:hive_flutter/hive_flutter.dart';

class HiveInterface {
  Map<String, Box> collection;

  HiveInterface({required this.collection});

  Box? getBoxbyName(String name) {
    return collection[name];
  }
}
