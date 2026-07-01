import 'package:flutter/material.dart';
import '../../settings/screens/settings_screen.dart';
import '../../notes/screens/notes_screen.dart';
import '../../about/screens/about_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.monetization_on,
                  color: theme.colorScheme.onSurface,
                  size: 45,
                ),

                const SizedBox(height: 15),

                Text(
                  "Fluxo",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Controla tu dinero con cabeza.",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Configuración",
            screen: const SettingsScreen(),
          ),

          _drawerItem(
            context,
            icon: Icons.event_note,
            title: "Futuros gastos",
            screen: const NotesScreen(),
          ),

          _drawerItem(
            context,
            icon: Icons.info_outline,
            title: "Acerca de Fluxo",
            screen: const AboutScreen(),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(
              "Fluxo v1.0",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget screen,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },
    );
  }
}