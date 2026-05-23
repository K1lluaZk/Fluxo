import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Inicialización de Hive para persistencia
  await Hive.initFlutter();
  await Hive.openBox('movimientos_box');
  runApp(const FluxoApp());
}

// --- MODELO DE DATOS ---
class Movimiento {
  final String id;
  final String titulo;
  final double monto;
  final bool ingreso;
  final DateTime fecha;

  Movimiento({
    required this.id,
    required this.titulo,
    required this.monto,
    required this.ingreso,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'monto': monto,
      'ingreso': ingreso,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Movimiento.fromMap(Map<dynamic, dynamic> map) {
    return Movimiento(
      id: map['id'],
      titulo: map['titulo'],
      monto: map['monto'],
      ingreso: map['ingreso'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}

class FluxoApp extends StatelessWidget {
  const FluxoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluxo',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1E40AF),
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF020617),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _myBox = Hive.box('movimientos_box');
  List<Movimiento> movimientos = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    if (_myBox.get("lista") != null) {
      final List<dynamic> datosRaw = _myBox.get("lista");
      setState(() {
        movimientos = datosRaw.map((m) => Movimiento.fromMap(m)).toList();
      });
    }
  }

  void _actualizarHive() {
    final List<Map<String, dynamic>> datosParaGuardar = 
        movimientos.map((m) => m.toMap()).toList();
    _myBox.put("lista", datosParaGuardar);
  }

  double get totalIngresos => movimientos.where((m) => m.ingreso).fold(0, (a, b) => a + b.monto);
  double get totalGastos => movimientos.where((m) => !m.ingreso).fold(0, (a, b) => a + b.monto);
  double get balance => totalIngresos - totalGastos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fluxo")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddMovimientoSheet(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildBalanceHeader(),
            const SizedBox(height: 30),
            _buildSummaryCards(),
            const SizedBox(height: 35),
            const Text("Movimientos recientes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: movimientos.isEmpty
                  ? const Center(child: Text("Sin movimientos guardados"))
                  : ListView.builder(
                      itemCount: movimientos.length,
                      itemBuilder: (context, index) {
                        final item = movimientos[index];
                        return GestureDetector(
                          onTap: () => _showDetalles(context, item),
                          child: Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              setState(() {
                                movimientos.removeAt(index);
                                _actualizarHive();
                              });
                            },
                            background: _buildDeleteBackground(),
                            child: MovimientoTile(item: item),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMovimientoSheet(BuildContext context) {
    final tituloController = TextEditingController();
    final montoController = TextEditingController();
    bool esIngreso = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SingleChildScrollView(
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
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 20),
                const Text("Nuevo Movimiento", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                Row(
                  children: [
                    _tipoBtn("INGRESO", esIngreso, () => setModalState(() => esIngreso = true)),
                    const SizedBox(width: 10),
                    _tipoBtn("GASTO", !esIngreso, () => setModalState(() => esIngreso = false)),
                  ],
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                    labelText: "Descripción", 
                    filled: true, 
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: "Monto", 
                    filled: true, 
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      final t = tituloController.text;
                      final m = double.tryParse(montoController.text) ?? 0;
                      if (t.isEmpty || m <= 0) return;
                      setState(() {
                        movimientos.insert(0, Movimiento(
                          id: DateTime.now().toString(), 
                          titulo: t, monto: m, ingreso: esIngreso, fecha: DateTime.now()
                        ));
                        _actualizarHive();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Guardar Movimiento", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tipoBtn(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1E40AF) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? Colors.transparent : Colors.white10),
          ),
          child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Colors.white : Colors.blueGrey))),
        ),
      ),
    );
  }

  Widget _buildBalanceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Balance Total", style: TextStyle(color: Colors.blueGrey, fontSize: 18)),
        const SizedBox(height: 8),
        Text("\$${balance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _statCard("Ingresos", "\$${totalIngresos.toStringAsFixed(0)}", Icons.arrow_downward, const Color(0xFF4ADE80)),
        const SizedBox(width: 15),
        _statCard("Gastos", "\$${totalGastos.toStringAsFixed(0)}", Icons.arrow_upward, const Color(0xFFF87171)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.blueGrey)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(18)),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _showDetalles(BuildContext context, Movimiento item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.ingreso ? "INGRESO" : "GASTO", style: TextStyle(color: item.ingreso ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(item.titulo, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text("${item.fecha.day}/${item.fecha.month}/${item.fecha.year}", style: const TextStyle(color: Colors.blueGrey)),
            const Divider(height: 40, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Monto", style: TextStyle(fontSize: 18)),
                Text("\$${item.monto.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: item.ingreso ? Colors.greenAccent : Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// --- COMPONENTE TILE CON ICONOS RESTAURADOS ---
class MovimientoTile extends StatelessWidget {
  final Movimiento item;
  const MovimientoTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.05),
            // ICONOS DE + Y - RESTAURADOS
            child: Icon(
              item.ingreso ? Icons.add_circle : Icons.remove_circle, 
              color: item.ingreso ? Colors.greenAccent : Colors.redAccent, 
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("Toca para detalles", style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
            ],
          )),
          Text(
            "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
            style: TextStyle(color: item.ingreso ? const Color(0xFF4ADE80) : const Color(0xFFF87171), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}