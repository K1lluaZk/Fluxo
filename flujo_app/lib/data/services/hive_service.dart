import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static final box = Hive.box('movimientos_box');

  static List<dynamic>? getMovimientos() {
    return box.get("lista");
  }

  static void saveMovimientos(List<Map<String, dynamic>> movimientos) {
    box.put("lista", movimientos);
  }
}