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

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text("Notas"),
        backgroundColor: const Color(0xFF0F172A),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddNoteSheet(context);
        },
      ),
      body: notas.isEmpty
          ? const Center(
              child: Text(
                "No hay notas todavía",
                style: TextStyle(color: Colors.blueGrey),
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
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.note_alt_outlined, color: Colors.white),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nota.titulo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                nota.descripcion,
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "\$${nota.monto.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Color(0xFFF87171),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Convertir en gasto",
                              icon: const Icon(
                                Icons.remove_circle,
                                color: Color(0xFFF87171),
                                size: 30,
                              ),
                              onPressed: () {
                                context.read<MovimientoProvider>().agregarMovimiento(
                                  Movimiento(
                                    id: DateTime.now().toString(),
                                    titulo: nota.titulo,
                                    monto: nota.monto,
                                    ingreso: false,
                                    fecha: DateTime.now(),
                                    categoria: "Pendiente",
                                  ),
                                );
                                context.read<NoteProvider>().eliminarNota(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Nota convertida en gasto")),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: "Convertir en ingreso",
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color(0xFF4ADE80),
                                size: 30,
                              ),
                              onPressed: () {
                                context.read<MovimientoProvider>().agregarMovimiento(
                                  Movimiento(
                                    id: DateTime.now().toString(),
                                    titulo: nota.titulo,
                                    monto: nota.monto,
                                    ingreso: true,
                                    fecha: DateTime.now(),
                                    categoria: "Pendiente",
                                  ),
                                );
                                context.read<NoteProvider>().eliminarNota(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Nota convertida en ingreso")),
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

  void _showAddNoteSheet(BuildContext context) {
    final controller = TextEditingController();
    final montoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => SingleChildScrollView(
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Nueva Nota",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: controller,
                maxLines: 4,
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
              TextField(
                controller: montoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 30),
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
                    if (controller.text.trim().isEmpty) return;

                    final monto = double.tryParse(montoController.text) ?? 0;

                    context.read<NoteProvider>().agregarNota(
                      Note(
                        id: DateTime.now().toString(),
                        titulo: controller.text.trim(),
                        descripcion: controller.text.trim(),
                        fecha: DateTime.now(),
                        monto: monto,
                        ingreso: monto >= 0,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Guardar Nota",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
