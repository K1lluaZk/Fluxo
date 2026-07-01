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
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      final theme = Theme.of(context);

      return Padding(
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
                  color: theme.dividerColor,
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
                color: item.ingreso
                    ? Colors.green.withOpacity(0.12)
                    : Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.ingreso ? "INGRESO" : "GASTO",
                style: TextStyle(
                  color: item.ingreso
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              item.titulo,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: theme.hintColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "${item.fecha.day}/${item.fecha.month}/${item.fecha.year}",
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            Divider(
              height: 50,
              color: theme.dividerColor,
            ),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Monto total",
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.hintColor,
                  ),
                ),
                Text(
                  "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: item.ingreso
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categoría",
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.hintColor,
                  ),
                ),
                Text(
                  item.categoria,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                      backgroundColor:
                          theme.colorScheme.primary,
                      foregroundColor:
                          theme.colorScheme.onPrimary,
                      minimumSize:
                          const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text(
                      "Editar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      final provider =
                          context.read<MovimientoProvider>();

                      Navigator.pop(context);

                      showEditMovimientoSheet(
                        context: context,
                        movimiento: item,
                        onSave: (movimientoActualizado) {
                          provider.editarMovimientoPorId(
                            item.id,
                            movimientoActualizado,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.error,
                      foregroundColor:
                          theme.colorScheme.onError,
                      minimumSize:
                          const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text(
                      "Eliminar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      final provider =
                          context.read<MovimientoProvider>();

                      provider.eliminarMovimientoPorId(
                        item.id,
                      );

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Movimiento eliminado",
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}