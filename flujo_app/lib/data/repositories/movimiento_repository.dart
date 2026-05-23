import '../models/movimiento.dart';
import '../services/hive_service.dart';

class MovimientoRepository {

  List<Movimiento> cargarMovimientos() {

    final data = HiveService.getMovimientos();

    if (data == null) return [];

    return data
        .map((e) => Movimiento.fromMap(e))
        .toList()
        .cast<Movimiento>();
  }

  void guardarMovimientos(List<Movimiento> movimientos) {

    final data =
        movimientos.map((e) => e.toMap()).toList();

    HiveService.saveMovimientos(data);
  }
}