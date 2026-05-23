import 'package:flutter/material.dart';
import '../../../../../data/models/movimiento.dart';

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
            backgroundColor:
                Colors.white.withOpacity(0.05),

            child: Icon(
              item.ingreso
                  ? Icons.add_circle
                  : Icons.remove_circle,

              color: item.ingreso
                  ? Colors.greenAccent
                  : Colors.redAccent,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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