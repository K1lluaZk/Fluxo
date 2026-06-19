import 'package:flutter/material.dart';
import '../../../../data/models/movimiento.dart';

void showEditMovimientoSheet({
  required BuildContext context,
  required Movimiento movimiento,
  required Function(Movimiento movimiento) onSave,
}) {
  final tituloController =
      TextEditingController(text: movimiento.titulo);

  final montoController =
      TextEditingController(
    text: movimiento.monto.toString(),
  );

  bool esIngreso = movimiento.ingreso;

  final List<String> categorias = [
    "Pendiente",
    "Comida",
    "Transporte",
    "Compras",
    "Trabajo",
    "Entretenimiento",
    "Salud",
  ];

  String categoriaSeleccionada =
      movimiento.categoria;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0F172A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
              bottom:
                  MediaQuery.of(context)
                          .viewInsets
                          .bottom +
                      60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Editar Movimiento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    _buildTipoBtn(
                      label: "INGRESO",
                      isSelected: esIngreso,
                      onTap: () {
                        setModalState(() {
                          esIngreso = true;
                        });
                      },
                    ),

                    const SizedBox(width: 10),

                    _buildTipoBtn(
                      label: "GASTO",
                      isSelected: !esIngreso,
                      onTap: () {
                        setModalState(() {
                          esIngreso = false;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: tituloController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: montoController,
                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Monto",
                    labelStyle: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  dropdownColor:
                      const Color(0xFF1E293B),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    labelStyle: const TextStyle(
                      color: Colors.blueGrey,
                    ),
                    filled: true,
                    fillColor:
                        Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categorias.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setModalState(() {
                        categoriaSeleccionada = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF1E40AF,
                      ),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                    onPressed: () {
                      final titulo =
                          tituloController.text.trim();

                      final monto =
                          double.tryParse(
                                montoController.text,
                              ) ??
                              0;

                      if (titulo.isEmpty ||
                          monto <= 0) {
                        return;
                      }

                      onSave(
                        Movimiento(
                          id: movimiento.id,
                          titulo: titulo,
                          monto: monto,
                          ingreso: esIngreso,
                          fecha: movimiento.fecha,
                          categoria:
                              categoriaSeleccionada,
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Guardar Cambios",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildTipoBtn({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E40AF)
              : Colors.white.withOpacity(0.05),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : Colors.blueGrey,
            ),
          ),
        ),
      ),
    ),
  );
}