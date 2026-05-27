import 'package:flutter/material.dart';
import '../../../../../data/models/movimiento.dart';

const Map<String, IconData> categoriasIconos = {
  "Comida": Icons.fastfood,
  "Transporte": Icons.directions_car,
  "Compras": Icons.shopping_bag,
  "Trabajo": Icons.work,
  "Entretenimiento": Icons.movie,
  "Salud": Icons.favorite,
};

class MovimientoTile extends StatelessWidget {
  final Movimiento item;

  const MovimientoTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (item.ingreso
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFF87171))
                .withOpacity(0.12),
            child: Icon(
              categoriasIconos[item.categoria] ?? Icons.attach_money,
              color: item.ingreso
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFFF87171),
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  item.categoria,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  "Toca para detalles",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
            style: TextStyle(
              color: item.ingreso
                  ? const Color(0xFF4ADE80)
                  : const Color(0xFFF87171),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
