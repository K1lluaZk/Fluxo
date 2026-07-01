import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  static const _boxName = "settings";
  static const _balanceKey = "mostrarBalance";
  static const _darkModeKey = "modoOscuro";

  bool _mostrarBalance = true;

  bool get mostrarBalance => _mostrarBalance;

  bool _modoOscuro = false;
  bool get modoOscuro => _modoOscuro;

  SettingsProvider() {
    _cargar();
  }

  void _cargar() {
    final box = Hive.box(_boxName);

    _mostrarBalance =
        box.get(_balanceKey, defaultValue: true);

    _modoOscuro = box.get(_darkModeKey, defaultValue: false); 

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

  void cambiarModoOscuro(bool value) {
  _modoOscuro = value;

  Hive.box(_boxName).put(
    _darkModeKey,
    value,
  );

  notifyListeners();
}
}