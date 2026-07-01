import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../../home/providers/movimiento_provider.dart';

import '../../../../data/models/note.dart';
import '../../../../data/models/movimiento.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final notas = noteProvider.notes;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final cardColor = theme.brightness == Brightness.dark
        ? const Color(0xFF161B22)
        : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notas"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        onPressed: () => _showAddNoteSheet(context),
        child: const Icon(Icons.add),
      ),
      body: notas.isEmpty
          ? Center(
              child: Text(
                "No hay notas todavía",
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                final nota = notas[index];

                return Dismissible(
                  key: Key(nota.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    context.read<NoteProvider>().eliminarNota(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: colorScheme.onError,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: colorScheme.secondary,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                nota.titulo,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                nota.descripcion,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary
                                      .withOpacity(0.12),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "RD\$ ${nota.monto.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color:
                                        colorScheme.secondary,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip:
                                  "Convertir en gasto",
                              icon: Icon(
                                Icons.remove_circle,
                                color: colorScheme.error,
                                size: 30,
                              ),
                              onPressed: () {
                                _procesarMovimiento(
                                  context,
                                  nota,
                                  index,
                                  false,
                                );
                              },
                            ),

                            IconButton(
                              tooltip:
                                  "Convertir en ingreso",
                              icon: Icon(
                                Icons.add_circle,
                                color:
                                    colorScheme.secondary,
                                size: 30,
                              ),
                              onPressed: () {
                                _procesarMovimiento(
                                  context,
                                  nota,
                                  index,
                                  true,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

    void _procesarMovimiento(
    BuildContext context,
    Note nota,
    int index,
    bool esIngreso,
  ) {
    context.read<MovimientoProvider>().agregarMovimiento(
          Movimiento(
            id: DateTime.now().toString(),
            titulo: nota.titulo,
            monto: nota.monto,
            ingreso: esIngreso,
            fecha: DateTime.now(),
            categoria: "Pendiente",
          ),
        );

    context.read<NoteProvider>().eliminarNota(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Nota convertida en ${esIngreso ? 'ingreso' : 'gasto'}",
        ),
      ),
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final fieldColor =
        theme.brightness == Brightness.dark
            ? const Color(0xFF1A1F29)
            : const Color(0xFFF0F4F3);

    final controller = TextEditingController();
    final montoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 25,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
                  60,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color:
                    colorScheme.onSurface.withOpacity(0.2),
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Nueva Nota",
              style: theme.textTheme.titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Descripción",
                filled: true,
                fillColor: fieldColor,
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
                  const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: "Monto",
                filled: true,
                fillColor: fieldColor,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      colorScheme.secondary,
                  foregroundColor:
                      colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (controller.text
                      .trim()
                      .isEmpty) {
                    return;
                  }

                  final monto =
                      double.tryParse(
                            montoController.text,
                          ) ??
                          0;

                  context
                      .read<NoteProvider>()
                      .agregarNota(
                        Note(
                          id: DateTime.now()
                              .toString(),
                          titulo:
                              controller.text.trim(),
                          descripcion:
                              controller.text.trim(),
                          fecha: DateTime.now(),
                          monto: monto,
                          ingreso: monto >= 0,
                        ),
                      );

                  Navigator.pop(context);
                },
                child: const Text(
                  "Guardar Nota",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}