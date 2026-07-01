import 'package:flutter/material.dart';
import '../../../../data/models/movimiento.dart';

void showAddMovimientoSheet({
  required BuildContext context,
  required Function(Movimiento movimiento) onSave,
}) {
  final tituloController = TextEditingController();
  final montoController = TextEditingController();

  bool esIngreso = true;

  final theme = Theme.of(context);

  final Color fieldColor = theme.brightness == Brightness.dark
      ? const Color(0xFF1A1F29)
      : const Color(0xFFF0F4F3);

  final List<String> categorias = [
    "Pendiente",
    "Comida",
    "Transporte",
    "Compras",
    "Trabajo",
    "Entretenimiento",
    "Salud",
    "Otras",
  ];

  String categoriaSeleccionada = "Pendiente";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        final theme = Theme.of(context);

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Nuevo Movimiento",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    _buildTipoBtn(
                      context: context,
                      label: "INGRESO",
                      isSelected: esIngreso,
                      onTap: () => setModalState(() => esIngreso = true),
                    ),
                    const SizedBox(width: 10),
                    _buildTipoBtn(
                      context: context,
                      label: "GASTO",
                      isSelected: !esIngreso,
                      onTap: () => setModalState(() => esIngreso = false),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: tituloController,
                  cursorColor: theme.colorScheme.secondary,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: "Descripción",
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: montoController,
                  cursorColor: theme.colorScheme.secondary,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: "Monto",
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: categoriaSeleccionada,
                  dropdownColor: theme.colorScheme.surface,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: "Categoría",
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  items: categorias.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    if (valor != null) {
                      setModalState(() {
                        categoriaSeleccionada = valor;
                      });
                    }
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: theme.colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      final titulo = tituloController.text.trim();
                      final monto =
                          double.tryParse(montoController.text) ?? 0;

                      if (titulo.isEmpty || monto <= 0) return;

                      onSave(
                        Movimiento(
                          id: DateTime.now().toString(),
                          titulo: titulo,
                          monto: monto,
                          ingreso: esIngreso,
                          fecha: DateTime.now(),
                          categoria: categoriaSeleccionada,
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Guardar Movimiento",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
  required BuildContext context,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);

  final Color background = theme.brightness == Brightness.dark
      ? const Color(0xFF1A1F29)
      : const Color(0xFFF0F4F3);

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.secondary
              : background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.secondary
                : theme.dividerColor,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),
  );
}