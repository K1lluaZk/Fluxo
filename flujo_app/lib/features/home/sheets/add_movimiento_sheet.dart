import 'package:flutter/material.dart';
import '../../../../data/models/movimiento.dart';

void showAddMovimientoSheet({
  required BuildContext context,
  required Function(Movimiento movimiento) onSave,
}) {
  final tituloController = TextEditingController();
  final montoController = TextEditingController();
  bool esIngreso = true;

  // Lista de categorías disponibles
  final List<String> categorias = [
    "Comida",
    "Transporte",
    "Compras",
    "Trabajo",
    "Entretenimiento",
    "Salud",
  ];

  // Categoría seleccionada por defecto
  String categoriaSeleccionada = "Comida";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0F172A), // Fondo oscuro
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
              // Ajuste para que suba más y no choque con el teclado
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Línea decorativa superior
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Nuevo Movimiento",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),

                // Selector de Tipo (Botones Ingreso/Gasto)
                Row(
                  children: [
                    _buildTipoBtn(
                      label: "INGRESO",
                      isSelected: esIngreso,
                      onTap: () => setModalState(() => esIngreso = true),
                    ),
                    const SizedBox(width: 10),
                    _buildTipoBtn(
                      label: "GASTO",
                      isSelected: !esIngreso,
                      onTap: () => setModalState(() => esIngreso = false),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Campo Descripción
                TextField(
                  controller: tituloController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: const TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Campo Monto
                TextField(
                  controller: montoController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Monto",
                    labelStyle: const TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Selector de Categoría (Dropdown)
                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  dropdownColor: const Color(0xFF1E293B), // Fondo del menú desplegable
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blueGrey),
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    labelStyle: const TextStyle(color: Colors.blueGrey),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: categorias.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (nuevoValor) {
                    if (nuevoValor != null) {
                      setModalState(() {
                        categoriaSeleccionada = nuevoValor;
                      });
                    }
                  },
                ),
                const SizedBox(height: 30),

                // Botón Guardar (Azul Marino Vibrante)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      final titulo = tituloController.text;
                      final monto = double.tryParse(montoController.text) ?? 0;

                      if (titulo.isEmpty || monto <= 0) return;

                      final movimiento = Movimiento(
                        id: DateTime.now().toString(),
                        titulo: titulo,
                        monto: monto,
                        ingreso: esIngreso,
                        fecha: DateTime.now(),
                        categoria: categoriaSeleccionada, // Asignación limpia del String seleccionado
                      );

                      onSave(movimiento);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Guardar Movimiento",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

// Widget auxiliar para los botones de tipo (Ingreso/Gasto)
Widget _buildTipoBtn({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white10,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
        ),
      ),
    ),
  );
}