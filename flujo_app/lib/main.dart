import 'package:flutter/material.dart';

void main() {
  runApp(const FluxoApp());
}

// --- MODELO DE DATOS ---
class Movimiento {
  final String id;
  final String titulo;
  final double monto;
  final bool ingreso;
  final DateTime fecha;
  final String categoria;

  Movimiento({
    required this.id,
    required this.titulo,
    required this.monto,
    required this.ingreso,
    required this.fecha,
    this.categoria = "General",
  });
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
          secondary: const Color(0xFF38B2AC),
          surface: const Color(0xFF0F172A),
        ),
        scaffoldBackgroundColor: const Color(0xFF020617),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
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
  final List<Movimiento> movimientos = [
    Movimiento(id: "1", titulo: "Pago Cliente", monto: 850.0, ingreso: true, fecha: DateTime.now()),
    Movimiento(id: "2", titulo: "Supermercado", monto: 120.0, ingreso: false, fecha: DateTime.now()),
  ];

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
                  ? const Center(child: Text("No hay movimientos"))
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
                              setState(() => movimientos.removeAt(index));
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

  // --- NUEVA FUNCIÓN: VER DETALLES ---
  void _showDetalles(BuildContext context, Movimiento item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),
            Text(item.ingreso ? "DETALLE DE INGRESO" : "DETALLE DE GASTO", 
                 style: TextStyle(color: item.ingreso ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 10),
            Text(item.titulo, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("${item.fecha.day}/${item.fecha.month}/${item.fecha.year}", style: const TextStyle(color: Colors.blueGrey)),
            const Divider(height: 40, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Monto total", style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                Text("\$${item.monto.toStringAsFixed(2)}", 
                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: item.ingreso ? Colors.greenAccent : Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Categoría: General", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            )
          ],
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
        Text("\$${balance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
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
            const SizedBox(height: 5),
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

  // --- MODAL DE AGREGAR CON SELECTOR ACCESIBLE ---
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
            padding: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: MediaQuery.of(context).viewInsets.bottom + 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Nuevo Movimiento", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),
                
                // SELECTOR DE TIPO (ACCESIBILIDAD MEJORADA)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => esIngreso = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: esIngreso ? const Color(0xFF1E40AF) : Colors.transparent,
                            border: Border.all(color: esIngreso ? Colors.transparent : Colors.white10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text("INGRESO", style: TextStyle(fontWeight: FontWeight.bold, color: esIngreso ? Colors.white : Colors.blueGrey))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => esIngreso = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !esIngreso ? const Color(0xFF1E40AF) : Colors.transparent,
                            border: Border.all(color: !esIngreso ? Colors.transparent : Colors.white10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: Text("GASTO", style: TextStyle(fontWeight: FontWeight.bold, color: !esIngreso ? Colors.white : Colors.blueGrey))),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: "Descripción", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: montoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: "Monto", filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      final t = tituloController.text;
                      final m = double.tryParse(montoController.text) ?? 0;
                      if (t.isEmpty || m <= 0) return;
                      setState(() => movimientos.insert(0, Movimiento(id: DateTime.now().toString(), titulo: t, monto: m, ingreso: esIngreso, fecha: DateTime.now())));
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
}

// --- COMPONENTE TILE ---
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
            child: Icon(item.ingreso ? Icons.arrow_downward : Icons.arrow_upward, 
                        color: item.ingreso ? Colors.greenAccent : Colors.redAccent, size: 18),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("Ver detalles", style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
            style: TextStyle(color: item.ingreso ? const Color(0xFF4ADE80) : const Color(0xFFF87171), fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}