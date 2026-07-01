import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/providers/movimiento_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificaciones = false;
  bool mostrarBalance = true;
  bool modoOscuro = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        title: const Text("Configuración"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Preferencias",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          _buildSwitchTile(
            title: "Mostrar balance",
            subtitle: "Oculta el dinero de la pantalla principal",
            value: mostrarBalance,
            onChanged: (value) {
              setState(() {
                mostrarBalance = value;
              });
            },
            icon: Icons.account_balance_wallet,
          ),

          const SizedBox(height: 10),

          _buildSwitchTile(
            title: "Modo oscuro",
            subtitle: "Tema oscuro elegante",
            value: modoOscuro,
            onChanged: (value) {
              setState(() {
                modoOscuro = value;
              });
            },
            icon: Icons.dark_mode,
          ),

          const SizedBox(height: 10),

          _buildSwitchTile(
            title: "Alertas",
            subtitle: "Activar futuras notificaciones",
            value: notificaciones,
            onChanged: (value) {
              setState(() {
                notificaciones = value;
              });
            },
            icon: Icons.notifications_active,
          ),

          const SizedBox(height: 35),

          const Text(
            "Datos",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              title: const Text(
                "Borrar historial completo",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                "Eliminar todos los movimientos",
                style: TextStyle(color: Colors.blueGrey),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF0F172A),
                    title: const Text(
                      "Eliminar historial",
                    ),
                    content: const Text(
                      "Esta acción eliminará todos los movimientos.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 252, 17, 17),
                        ),
                        onPressed: () {
                          context.read<MovimientoProvider>().borrarHistorial();

                          
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Historial eliminado",
                              ),
                            ),
                          );
                        },
                        child: const Text("Eliminar"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1E40AF),
        secondary: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.blueGrey),
        ),
      ),
    );
  }
}