import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../../home/providers/movimiento_provider.dart';
import '../../../../data/models/note.dart';
import '../../../../data/models/movimiento.dart';
import '../../../../data/services/notification_service.dart';

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: colorScheme.secondary,
                          size: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nota.titulo,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                nota.descripcion,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary.withOpacity(.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "RD\$ ${nota.monto.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (nota.fechaVencimiento != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.calendar_today, size: 14, color: Colors.orange),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${nota.fechaVencimiento!.day}/${nota.fechaVencimiento!.month}/${nota.fechaVencimiento!.year}",
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (nota.recordar)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.notifications_active, size: 14, color: Colors.blue),
                                          SizedBox(width: 5),
                                          Text(
                                            "Recordatorio",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              tooltip: "Convertir en gasto",
                              icon: Icon(Icons.remove_circle, color: colorScheme.error, size: 30),
                              onPressed: () => _procesarMovimiento(context, nota, index, false),
                            ),
                            IconButton(
                              tooltip: "Convertir en ingreso",
                              icon: Icon(Icons.add_circle, color: colorScheme.secondary, size: 30),
                              onPressed: () => _procesarMovimiento(context, nota, index, true),
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

  void _procesarMovimiento(BuildContext context, Note nota, int index, bool esIngreso) {
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
        content: Text("Nota convertida en ${esIngreso ? 'ingreso' : 'gasto'}"),
      ),
    );
  }

  void _showAddNoteSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fieldColor = theme.brightness == Brightness.dark
        ? const Color(0xFF1A1F29)
        : const Color(0xFFF0F4F3);

    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    final montoController = TextEditingController();
    DateTime? fechaVencimiento;
    bool recordar = false;
    int diasAntes = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25,
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Nueva Nota", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  TextField(
                    controller: tituloController,
                    decoration: InputDecoration(labelText: "Título", filled: true, fillColor: fieldColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: descripcionController,
                    maxLines: 4,
                    decoration: InputDecoration(labelText: "Descripción", filled: true, fillColor: fieldColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: montoController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: "Monto", filled: true, fillColor: fieldColor, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.calendar_month, color: colorScheme.secondary),
                    title: Text(fechaVencimiento == null
                        ? "Seleccionar fecha de vencimiento"
                        : "Vence el ${fechaVencimiento!.day}/${fechaVencimiento!.month}/${fechaVencimiento!.year}"),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                           builder: (context, child) {
 
                    final theme = Theme.of(context);
                    final colorScheme = theme.colorScheme;

                    return Theme(
                      data: theme.copyWith(
                        colorScheme: colorScheme,
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.secondary,
                             ),
                           ),
                        ),
                          child: child!,
                        );
                      },

                        );
                        if (fecha != null) setState(() => fechaVencimiento = fecha);
                      },
                      child: const Text("Elegir"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    value: recordar,
                    activeColor: colorScheme.secondary,
                    title: const Text("Recordarme"),
                    onChanged: (value) => setState(() => recordar = value),
                  ),
                  if (recordar) ...[
                    DropdownButtonFormField<int>(
                      value: diasAntes,
                      items: const [
                        DropdownMenuItem(value: 0, child: Text("El mismo día")),
                        DropdownMenuItem(value: 1, child: Text("1 día antes")),
                        DropdownMenuItem(value: 7, child: Text("1 semana antes")),
                      ],
                      onChanged: (value) => setState(() => diasAntes = value!),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: colorScheme.secondary, foregroundColor: colorScheme.onSecondary),
                      onPressed: () async {
                        if (tituloController.text.trim().isEmpty) return;
                        final monto = double.tryParse(montoController.text) ?? 0;
                        final nota = Note(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          titulo: tituloController.text.trim(),
                          descripcion: descripcionController.text.trim(),
                          fecha: DateTime.now(),
                          monto: monto,
                          ingreso: monto >= 0,
                          fechaVencimiento: fechaVencimiento,
                          recordar: recordar,
                          diasAntes: diasAntes,
                        );

                        context.read<NoteProvider>().agregarNota(nota);

                        if (recordar) {
                          await NotificationService.instance.show(
                            title: "¡Recordatorio activado!",
                            body: "Gracias por activar el recordatorio. Estaré pendiente de tus notas.",
                          );
                        }

                        if (recordar && fechaVencimiento != null) {
                          await NotificationService.instance.scheduleNoteReminder(nota);
                        }

                        Navigator.pop(context);
                      },
                      child: const Text("Guardar Nota"),
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
}