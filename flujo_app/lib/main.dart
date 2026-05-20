import 'package:flutter/material.dart';

void main() {
  runApp(const FluxoApp());
}

// --- MODELO DE DATOS ---
class Movimiento {
  final String titulo;
  final double monto;
  final bool ingreso;

  Movimiento({
    required this.titulo,
    required this.monto,
    required this.ingreso,
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
          primary: const Color(0xFF9203D4),
          secondary: const Color(0xFFB15CFF),
          surface: const Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
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
  // Lista de datos inicial
  final List<Movimiento> movimientos = [
    Movimiento(titulo: "Pago Cliente", monto: 850, ingreso: true),
    Movimiento(titulo: "Supermercado", monto: 120, ingreso: false),
  ];

  // --- LÓGICA DE CÁLCULOS ---
  double get totalIngresos => movimientos.where((m) => m.ingreso).fold(0, (a, b) => a + b.monto);
  double get totalGastos => movimientos.where((m) => !m.ingreso).fold(0, (a, b) => a + b.monto);
  double get balance => totalIngresos - totalGastos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fluxo")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C3AED),
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
            const Text(
              "Movimientos recientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: movimientos.isEmpty
                  ? const Center(child: Text("No hay movimientos"))
                  : ListView.builder(
                      itemCount: movimientos.length,
                      itemBuilder: (context, index) {
                        final item = movimientos[index];
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            setState(() {
                              movimientos.removeAt(index);
                            });
                          },
                          background: _buildDeleteBackground(),
                          child: MovimientoTile(
                            icon: item.ingreso ? Icons.attach_money : Icons.shopping_bag,
                            titulo: item.titulo,
                            subtitulo: item.ingreso ? "Ingreso" : "Gasto",
                            monto: "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
                            color: item.ingreso ? Colors.green : Colors.red,
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

  // --- WIDGETS DE LA INTERFAZ ---

  Widget _buildBalanceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Balance Total", style: TextStyle(color: Colors.grey, fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          "\$${balance.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _statCard("Ingresos", "\$${totalIngresos.toStringAsFixed(0)}", Icons.arrow_downward, Colors.green),
        const SizedBox(width: 15),
        _statCard("Gastos", "\$${totalGastos.toStringAsFixed(0)}", Icons.arrow_upward, Colors.red),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.grey)),
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
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  // --- MODAL PARA AGREGAR ---
  void _showAddMovimientoSheet(BuildContext context) {
    final tituloController = TextEditingController();
    final montoController = TextEditingController();
    bool esIngreso = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(labelText: "Descripción"),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: montoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Monto"),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                    value: esIngreso,
                    title: Text(esIngreso ? "Ingreso" : "Gasto"),
                    onChanged: (v) => setModalState(() => esIngreso = v),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final t = tituloController.text;
                        final m = double.tryParse(montoController.text) ?? 0;
                        if (t.isEmpty || m <= 0) return;

                        setState(() {
                          movimientos.insert(0, Movimiento(titulo: t, monto: m, ingreso: esIngreso));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Guardar"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// --- COMPONENTE TILE ---
class MovimientoTile extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final String monto;
  final Color color;

  const MovimientoTile({
    super.key,
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.monto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitulo, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(
            monto,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}