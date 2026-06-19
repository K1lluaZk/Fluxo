import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/movimiento.dart';
import '../providers/movimiento_provider.dart';
import 'edit_movimiento_sheet.dart';

void showDetalleMovimiento(
  BuildContext context,
  Movimiento item,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0F172A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) => Padding(
     padding: const EdgeInsets.fromLTRB(30, 20, 30, 55),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: (item.ingreso ? Colors.greenAccent : Colors.redAccent)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.ingreso ? "INGRESO" : "GASTO",
              style: TextStyle(
                color: item.ingreso ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Text(
            item.titulo,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.blueGrey,
              ),
              const SizedBox(width: 8),
              Text(
                "${item.fecha.day}/${item.fecha.month}/${item.fecha.year}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Divider(height: 50, color: Colors.white10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Monto total",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              Text(
                "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: item.ingreso
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFFF87171),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categoría",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              Text(
                item.categoria,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Editar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final provider = context.read<MovimientoProvider>();

                    Navigator.pop(context);

                    showEditMovimientoSheet(
                      context: context,
                      movimiento: item,
                      onSave: (movimientoActualizado) {
                        provider.editarMovimientoPorId(item.id, movimientoActualizado);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF87171),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text(
                    "Eliminar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    final provider = context.read<MovimientoProvider>();
                    provider.eliminarMovimientoPorId(item.id);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Movimiento eliminado"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
