class Movimiento {
  final String id;
  final String titulo;
  final double monto;
  final bool ingreso;
  final DateTime fecha;

  Movimiento({
    required this.id,
    required this.titulo,
    required this.monto,
    required this.ingreso,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'monto': monto,
      'ingreso': ingreso,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Movimiento.fromMap(Map<dynamic, dynamic> map) {
    return Movimiento(
      id: map['id'],
      titulo: map['titulo'],
      monto: map['monto'],
      ingreso: map['ingreso'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}