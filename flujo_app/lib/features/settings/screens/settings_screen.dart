import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/providers/movimiento_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  bool notificaciones = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Configuración"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Preferencias",
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          _buildSwitchTile(
            context,
            title: "Mostrar balance",
            subtitle: "Oculta el dinero de la pantalla principal",
            value: settings.mostrarBalance,
            onChanged: (value) => context.read<SettingsProvider>().cambiarMostrarBalance(value),
            icon: Icons.account_balance_wallet,
          ),
          const SizedBox(height: 10),
          _buildSwitchTile(
            context,
            title: "Modo oscuro",
            subtitle: "Tema oscuro elegante",
            value: settings.modoOscuro,
            onChanged: (value) => context.read<SettingsProvider>().cambiarModoOscuro(value),
            icon: Icons.dark_mode,
          ),
          const SizedBox(height: 35),
          Text(
            "Datos",
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: Icon(Icons.delete_forever, color: colorScheme.error),
              title: Text("Borrar historial completo", style: TextStyle(color: colorScheme.onSurface)),
              subtitle: Text("Eliminar todos los movimientos", style: TextStyle(color: colorScheme.onSurfaceVariant)),
              onTap: () => _confirmarBorrado(context),
            ),
          ),
        ],
      ),
    );
  }

void _confirmarBorrado(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Eliminar historial"),
      content: const Text("Esta acción eliminará todos los movimientos."),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () {
            context.read<MovimientoProvider>().borrarHistorial();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Historial eliminado")),
            );
          },
          child: const Text("Eliminar"),
        ),
      ],
    ),
  );
}

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

return Container(
  decoration: BoxDecoration(
    color: theme.brightness == Brightness.dark
        ? const Color(0xFF161B22)
        : Colors.white,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: theme.brightness == Brightness.dark
          ? Colors.white10
          : Colors.grey.shade300,
    ),
    boxShadow: theme.brightness == Brightness.light
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
        : [],
  ),
  child: SwitchListTile(
    value: value,
    onChanged: onChanged,

    activeColor: theme.colorScheme.secondary,

    inactiveThumbColor: theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600,

    inactiveTrackColor: theme.brightness == Brightness.dark
        ? Colors.white10
        : Colors.grey.shade300,

    secondary: Icon(
      icon,
      color: theme.colorScheme.onSurface,
    ),

    title: Text(
      title,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),

    subtitle: Text(
      subtitle,
      style: TextStyle(
        color: theme.hintColor,
      ),
    ),
  ),
);
  }
}