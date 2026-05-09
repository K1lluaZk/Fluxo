import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FluxoHome(),
  ));
}

class ArchivoEnviado {
  final String nombre;
  final String hora;
  final String tamano;

  ArchivoEnviado({
    required this.nombre,
    required this.hora,
    required this.tamano,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'hora': hora,
        'tamano': tamano,
      };

  factory ArchivoEnviado.fromMap(Map<String, dynamic> map) {
    return ArchivoEnviado(
      nombre: map['nombre'],
      hora: map['hora'],
      tamano: map['tamano'],
    );
  }
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
  ServerSocket? serverSocket;

  static const int puertoRecibir = 5006;
  static const String separator = "<SEPARATOR>";

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
    _iniciarServidor();
  }

  @override
  void dispose() {
    serverSocket?.close();
    super.dispose();
  }

  // ==========================================
  // SERVIDOR RECEPTOR (PC -> CELULAR)
  // ==========================================
  Future<void> _iniciarServidor() async {
    try {
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, puertoRecibir);
      setState(() => estado = "Fluxo Activo");

      serverSocket!.listen((Socket cliente) {
        String? nombreArchivo;
        int? tamanoArchivo;
        IOSink? sink;
        int recibido = 0;
        bool metadataLista = false;

        cliente.listen((Uint8List data) async {
          if (!metadataLista) {
            String texto = utf8.decode(data, allowMalformed: true);
            if (texto.contains(separator)) {
              final parts = texto.split(separator);
              nombreArchivo = parts[0];
              tamanoArchivo = int.parse(parts[1]);
              metadataLista = true;

              cliente.write("READY");

              final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
              final file = File("${dir.path}/$nombreArchivo");
              sink = file.openWrite();
              
              setState(() => estado = "Recibiendo $nombreArchivo...");
            }
          } else {
            // Recibiendo bytes del archivo
            sink?.add(data);
            recibido += data.length;

            if (tamanoArchivo != null && recibido >= tamanoArchivo!) {
              await sink?.flush();
              await sink?.close();
              cliente.write("RECIBIDO");
              
              _actualizarHistorial(nombreArchivo!, tamanoArchivo!);
              cliente.destroy();
            }
          }
        }, onDone: () => sink?.close());
      });
    } catch (e) {
      setState(() => estado = "Error servidor: $e");
    }
  }

  // ==========================================
  // ENVIAR ARCHIVO (CELULAR -> PC)
  // ==========================================
  Future<void> enviarArchivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    File file = File(result.files.single.path!);
    String nombre = p.basename(file.path);
    int size = await file.length();

    setState(() => estado = "Conectando al PC...");

    try {
      Socket socket = await Socket.connect(serverIp, 5005, timeout: const Duration(seconds: 10));

      // 1. Enviar Metadata
      socket.write("$nombre$separator$size");
      await socket.flush();

      // 2. Escuchar Respuesta (Sin romper el Stream)
      bool enviado = false;
      await for (var data in socket) {
        String res = utf8.decode(data);

        if (res.contains("READY")) {
          setState(() => estado = "Enviando $nombre...");
          await socket.addStream(file.openRead());
          await socket.flush();
          // Importante: No cerramos el socket aún, esperamos confirmación final de Python si la envía
        } 
        
        if (res.contains("RECIBIDO") || res.contains("OK")) {
          enviado = true;
          break; // Salimos del bucle al terminar
        }
        
        // Si Python no manda confirmación final, rompemos después de addStream
        if (res.contains("READY") && enviado == false) {
           enviado = true; 
           break;
        }
      }

      await socket.close();
      if (enviado) {
        _actualizarHistorial(nombre, size);
      }

    } catch (e) {
      setState(() => estado = "Error: $e");
    }
  }

  void _actualizarHistorial(String nombre, int size) {
    setState(() {
      estado = "¡Listo!";
      historial.insert(0, ArchivoEnviado(
        nombre: nombre,
        hora: TimeOfDay.now().format(context),
        tamano: "${(size / 1024).toStringAsFixed(2)} KB",
      ));
    });
    _guardarHistorial();
  }

  // =========================
  // PERSISTENCIA
  // =========================
  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = historial.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList("historial_fluxo", data);
  }

  Future<void> _cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("historial_fluxo");
    if (data != null) {
      setState(() {
        historial = data.map((e) => ArchivoEnviado.fromMap(jsonDecode(e))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fluxo"),
        backgroundColor: const Color.fromARGB(255, 146, 3, 212),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.sync_alt, size: 50, color: Colors.blueGrey),
                const SizedBox(height: 10),
                Text(estado, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: enviarArchivo,
                  icon: const Icon(Icons.upload),
                  label: const Text("Enviar archivo"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: historial.isEmpty
                ? const Center(child: Text("Sin archivos"))
                : ListView.builder(
                    itemCount: historial.length,
                    itemBuilder: (c, i) {
                      final item = historial[i];
                      return ListTile(
                        leading: const Icon(Icons.file_copy),
                        title: Text(item.nombre),
                        subtitle: Text("${item.hora} • ${item.tamano}"),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}