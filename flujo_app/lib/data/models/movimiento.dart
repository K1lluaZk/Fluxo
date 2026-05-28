import 'package:hive/hive.dart';

part 'movimiento.g.dart';

@HiveType(typeId: 0)
class Movimiento {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final double monto;

  @HiveField(3)
  final bool ingreso;

  @HiveField(4)
  final DateTime fecha;

  @HiveField(5)
  final String categoria;

  Movimiento({
    required this.id,
    required this.titulo,
    required this.monto,
    required this.ingreso,
    required this.fecha,
    required this.categoria,
  });
}