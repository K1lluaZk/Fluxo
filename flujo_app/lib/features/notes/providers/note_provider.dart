import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../data/models/note.dart';

class NoteProvider extends ChangeNotifier {
  static const String _boxName = 'notes_box';

  List<Note> _notes = [];

  NoteProvider() {
    _cargarNotas();
  }

  // =========================
  // GETTER
  // =========================

  List<Note> get notes =>
      List.unmodifiable(_notes);

  // =========================
  // CARGAR
  // =========================

  void _cargarNotas() {
    final box = Hive.box<Note>(_boxName);

    _notes = box.values
        .toList()
        .cast<Note>()
        .reversed
        .toList();

    notifyListeners();
  }

  // =========================
  // AGREGAR
  // =========================

  Future<void> agregarNota(
    Note note,
  ) async {
    _notes.insert(0, note);

    final box = Hive.box<Note>(_boxName);

    await box.add(note);

    notifyListeners();
  }

  // =========================
  // ELIMINAR
  // =========================

  Future<void> eliminarNota(
    int index,
  ) async {
    final note = _notes[index];

    _notes.removeAt(index);

    final box = Hive.box<Note>(_boxName);

    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == note.id,
    );

    await box.delete(key);

    notifyListeners();
  }

  // =========================
  // LIMPIAR TODO
  // =========================

  Future<void> eliminarTodas() async {
    final box = Hive.box<Note>(_boxName);

    await box.clear();

    _notes.clear();

    notifyListeners();
  }

  // =========================
  // BUSCAR POR ID
  // =========================

  Note? obtenerPorId(String id) {
    try {
      return _notes.firstWhere(
        (n) => n.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}