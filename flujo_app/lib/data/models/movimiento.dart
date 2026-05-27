class Movimiento {
  final String id;
  final String titulo;
  final double monto;
  final bool ingreso;
  final DateTime fecha;
  final String categoria;

  Movimiento({
    required this.id,
    required this.titulo,
    required this.monto,
    required this.ingreso,
    required this.fecha,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'monto': monto,
      'ingreso': ingreso,
      'fecha': fecha.toIso8601String(),
      'categoria': categoria,
    };
  }

  factory Movimiento.fromMap(Map<dynamic, dynamic> map) {
    return Movimiento(
      id: map['id'],
      titulo: map['titulo'],
      monto: map['monto'],
      ingreso: map['ingreso'],
      fecha: DateTime.parse(map['fecha']),
      categoria: map['categoria'],
    );
  }
}