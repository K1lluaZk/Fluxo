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
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.ingreso
                ? colors.tertiary.withOpacity(0.12)
                : colors.error.withOpacity(0.12),
            child: Icon(
              categoriasIconos[item.categoria] ??
                  Icons.attach_money,
              color: item.ingreso
                  ? colors.tertiary
                  : colors.error,
              size: 22,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.onPrimary,
                  ),
                ),

                Text(
                  item.categoria,
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.65),
                    fontSize: 12,
                  ),
                ),

                Text(
                  "Toca para detalles",
                  style: TextStyle(
                    color: colors.onPrimary.withOpacity(0.65),
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
                  ? colors.tertiary
                  : colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}