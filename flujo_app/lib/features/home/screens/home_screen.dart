import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/balance_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/delete_background.dart';
import '../widgets/movimiento_tile.dart';
import '../sheets/add_movimiento_sheet.dart';
import '../sheets/detalle_movimiento_sheet.dart';
import '../providers/movimiento_provider.dart';
import '../widgets/charts/balance_chart.dart';
import '../widgets/app_drawer.dart';

// --- VISTA (HOME SCREEN) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el provider centralizado
    final movimientoProvider = context.watch<MovimientoProvider>();
    final movimientos = movimientoProvider.movimientos;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Fluxo"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMovimientoSheet(
            context: context,
            onSave: (movimiento) {
              // Centralizado: Agrega y guarda en Hive en un solo paso
              context.read<MovimientoProvider>().agregarMovimiento(movimiento);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            BalanceHeader(
              balance: movimientoProvider.balance,
            ),

            const SizedBox(height: 25),

            BalanceChart(
              ingresos: movimientoProvider.totalIngresos,
              gastos: movimientoProvider.totalGastos,
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                StatCard(
                  label: "Ingresos",
                  value: "\$${movimientoProvider.totalIngresos.toStringAsFixed(0)}",
                  icon: Icons.arrow_downward,
                  color: const Color(0xFF4ADE80),
                ),
                const SizedBox(width: 15),
                StatCard(
                  label: "Gastos",
                  value: "\$${movimientoProvider.totalGastos.toStringAsFixed(0)}",
                  icon: Icons.arrow_upward,
                  color: const Color(0xFFF87171),
                ),
              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "Movimientos recientes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            movimientos.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Text("Sin movimientos"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: movimientos.length,
                    itemBuilder: (context, index) {
                      final item = movimientos[index];

                      return GestureDetector(
                        onTap: () {
                          showDetalleMovimiento(
                            context,
                            item,
                          );
                        },
                        child: Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            context
                                .read<MovimientoProvider>()
                                .eliminarMovimiento(index);
                          },
                          background: const DeleteBackground(),
                          child: MovimientoTile(
                            item: item,
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}