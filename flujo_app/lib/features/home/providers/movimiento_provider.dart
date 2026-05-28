import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../data/models/movimiento.dart';

class MovimientoProvider extends ChangeNotifier {
  static const String _boxName =
      'movimientos_box';

  List<Movimiento> _movimientos = [];

  MovimientoProvider() {
    _cargarMovimientosDeHive();
  }

  // =========================
  // GETTER
  // =========================
  List<Movimiento> get movimientos =>
      List.unmodifiable(_movimientos);

  // =========================
  // CARGAR
  // =========================
  void _cargarMovimientosDeHive() {
    final box =
        Hive.box<Movimiento>(_boxName);

    _movimientos = box.values
        .toList()
        .cast<Movimiento>()
        .reversed
        .toList();

    notifyListeners();
  }

  // =========================
  // AGREGAR
  // =========================
  void agregarMovimiento(
    Movimiento movimiento,
  ) {
    _movimientos.insert(0, movimiento);

    final box =
        Hive.box<Movimiento>(_boxName);

    box.add(movimiento);

    notifyListeners();
  }

  // =========================
  // ELIMINAR
  // =========================
  void eliminarMovimiento(int index) {
    final movimientoAEliminar =
        _movimientos[index];

    _movimientos.removeAt(index);

    final box =
        Hive.box<Movimiento>(_boxName);

    final key = box.keys.firstWhere(
      (k) =>
          box.get(k)?.id ==
          movimientoAEliminar.id,
    );

    box.delete(key);

    notifyListeners();
  }

  // =========================
  // TOTALES
  // =========================
  double get totalIngresos =>
      _movimientos
          .where((m) => m.ingreso)
          .fold(
            0.0,
            (a, b) => a + b.monto,
          );

  double get totalGastos =>
      _movimientos
          .where((m) => !m.ingreso)
          .fold(
            0.0,
            (a, b) => a + b.monto,
          );

  double get balance =>
      totalIngresos - totalGastos;
}