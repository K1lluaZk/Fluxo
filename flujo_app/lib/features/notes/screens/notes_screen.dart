import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> notas = [];

  final TextEditingController controller =
      TextEditingController();

  void agregarNota() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      notas.insert(
        0,
        controller.text.trim(),
      );
    });

    controller.clear();
  }

  void eliminarNota(int index) {
    setState(() {
      notas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        title: const Text("Notas"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _showAddNoteSheet(context);
        },
      ),

      body: notas.isEmpty
          ? const Center(
              child: Text(
                "No hay notas todavía",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(notas[index]),
                  direction:
                      DismissDirection.endToStart,
                  onDismissed: (_) {
                    eliminarNota(index);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    margin:
                        const EdgeInsets.only(
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 15,
                    ),
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF1E293B),
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          color: Colors.white,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Text(
                            notas[index],
                            style: const TextStyle(
                              fontSize: 16,
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

  void _showAddNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          const Color(0xFF0F172A),
      shape:
          const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            top: 25,
            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    40,
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
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Nueva Nota",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText:
                      "Escribe algo...",
                  hintStyle:
                      const TextStyle(
                    color: Colors.blueGrey,
                  ),
                  filled: true,
                  fillColor:
                      Colors.white.withOpacity(
                    0.05,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

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
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    agregarNota();

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Guardar Nota",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}