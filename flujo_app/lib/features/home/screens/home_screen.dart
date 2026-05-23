import 'package:flutter/material.dart';

import '../../../../data/models/movimiento.dart';
import '../../../../data/repositories/movimiento_repository.dart';

import '../widgets/balance_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/delete_background.dart';
import '../widgets/movimiento_tile.dart';

import '../sheets/add_movimiento_sheet.dart';
import '../sheets/detalle_movimiento_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  final repository =
      MovimientoRepository();

  List<Movimiento> movimientos = [];

  @override
  void initState() {
    super.initState();

    movimientos =
        repository.cargarMovimientos();
  }

  void guardarMovimientos() {
    repository.guardarMovimientos(
      movimientos,
    );
  }

  double get totalIngresos =>
      movimientos
          .where((m) => m.ingreso)
          .fold(
            0,
            (a, b) => a + b.monto,
          );

  double get totalGastos =>
      movimientos
          .where((m) => !m.ingreso)
          .fold(
            0,
            (a, b) => a + b.monto,
          );

  double get balance =>
      totalIngresos - totalGastos;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Fluxo"),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () {
          showAddMovimientoSheet(
            context: context,

            onSave: (movimiento) {

              setState(() {

                movimientos.insert(
                  0,
                  movimiento,
                );

                guardarMovimientos();
              });
            },
          );
        },

        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 20),

            BalanceHeader(
              balance: balance,
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                StatCard(
                  label: "Ingresos",
                  value:
                      "\$${totalIngresos.toStringAsFixed(0)}",

                  icon:
                      Icons.arrow_downward,

                  color:
                      const Color(0xFF4ADE80),
                ),

                const SizedBox(width: 15),

                StatCard(
                  label: "Gastos",
                  value:
                      "\$${totalGastos.toStringAsFixed(0)}",

                  icon:
                      Icons.arrow_upward,

                  color:
                      const Color(0xFFF87171),
                ),
              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "Movimientos recientes",

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: movimientos.isEmpty

                  ? const Center(
                      child: Text(
                        "Sin movimientos",
                      ),
                    )

                  : ListView.builder(
                      itemCount:
                          movimientos.length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            movimientos[
                                index];

                        return GestureDetector(

                          onTap: () {
                            showDetalleMovimiento(
                              context,
                              item,
                            );
                          },

                          child: Dismissible(
                            key: Key(item.id),

                            direction:
                                DismissDirection
                                    .endToStart,

                            onDismissed: (_) {

                              setState(() {

                                movimientos
                                    .removeAt(
                                  index,
                                );

                                guardarMovimientos();
                              });
                            },

                            background:
                                const DeleteBackground(),

                            child:
                                MovimientoTile(
                              item: item,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}