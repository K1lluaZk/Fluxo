import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  static const _boxName = "settings";
  static const _balanceKey = "mostrarBalance";

  bool _mostrarBalance = true;

  bool get mostrarBalance => _mostrarBalance;

  SettingsProvider() {
    _cargar();
  }

  void _cargar() {
    final box = Hive.box(_boxName);

    _mostrarBalance =
        box.get(_balanceKey, defaultValue: true);

    notifyListeners();
  }

  void cambiarMostrarBalance(bool value) {
    _mostrarBalance = value;

    Hive.box(_boxName).put(
      _balanceKey,
      value,
    );

    notifyListeners();
  }
}