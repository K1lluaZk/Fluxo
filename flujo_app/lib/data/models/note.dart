import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String titulo;

  @HiveField(2)
  String descripcion;

  @HiveField(3)
  DateTime fecha;

  @HiveField(4)
  double monto;

  @HiveField(5)
  bool ingreso;

  @HiveField(6)
  bool completada;

  Note({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.monto,
    required this.ingreso,
    this.completada = false,
  });
}