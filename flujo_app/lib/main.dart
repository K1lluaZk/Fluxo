import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart'; 

void main() {
  runApp(const MaterialApp(home: FluxoHome()));
}

class ArchivoEnviado {
  final String nombre;
  final String hora;
  final String tamano;

  ArchivoEnviado({required this.nombre, required this.hora, required this.tamano});

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'hora': hora,
        'tamano': tamano,
      };

  // Creamos el objeto desde un mapa (cuando lo leemos del disco)
  factory ArchivoEnviado.fromMap(Map<String, dynamic> map) => ArchivoEnviado(
        nombre: map['nombre'],
        hora: map['hora'],
        tamano: map['tamano'],
      );
}

class FluxoHome extends StatefulWidget {
  const FluxoHome({super.key});

  @override
  State<FluxoHome> createState() => _FluxoHomeState();
}

class _FluxoHomeState extends State<FluxoHome> {
  final String serverIp = "192.168.100.4";
  String estado = "Esperando...";
  List<ArchivoEnviado> historial = [];

  @override
  void initState() {
    super.initState();
    _cargarHistorial(); 
  }


  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> datos = historial.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('historial_fluxo', datos);
  }

  Future<void> _cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? datos = prefs.getStringList('historial_fluxo');
    if (datos != null) {
      setState(() {
        historial = datos.map((e) => ArchivoEnviado.fromMap(jsonDecode(e))).toList();
      });
    }
  }

  Future<void> _limpiarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('historial_fluxo');
    setState(() {
      historial.clear();
    });
  }


  Future<void> enviarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String nombre = p.basename(file.path);
      int tamanoRaw = await file.length();
      String tamanoLegible = "${(tamanoRaw / 1024).toStringAsFixed(2)} KB";

      setState(() => estado = "Conectando al PC...");

      try {
        Socket socket = await Socket.connect(serverIp, 5005, timeout: const Duration(seconds: 5));
        socket.write("$nombre<SEPARATOR>$tamanoRaw");

        await for (var data in socket) {
          String respuesta = utf8.decode(data);
          if (respuesta == "READY") {
            setState(() => estado = "Enviando $nombre...");
            await socket.addStream(file.openRead());
            break;
          }
        }

        await socket.flush();
        await socket.close();

        setState(() {
          estado = "¡Enviado con éxito!";
          historial.insert(0, ArchivoEnviado(
            nombre: nombre,
            hora: TimeOfDay.now().format(context),
            tamano: tamanoLegible,
          ));
        });

        await _guardarHistorial();

      } catch (e) {
        setState(() => estado = "Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fluxo"),
        backgroundColor: const Color.fromARGB(255, 146, 3, 212),
        foregroundColor: Colors.white,
        actions: [
          // Botón para borrar historial en la parte superior
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              if (historial.isNotEmpty) _limpiarHistorial();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.blueGrey),
                const SizedBox(height: 10),
                Text(estado, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: enviarArchivo,
                  icon: const Icon(Icons.add),
                  label: const Text("Enviar Archivo"),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 45)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: historial.isEmpty
                  ? const Center(child: Text("El historial está vacío", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: historial.length,
                      itemBuilder: (context, index) {
                        final item = historial[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.description, color: Colors.blueAccent),
                            title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w500)),
                            subtitle: Text("Hora: ${item.hora} • ${item.tamano}"),
                            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}