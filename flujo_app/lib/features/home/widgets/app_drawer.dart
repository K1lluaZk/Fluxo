import 'package:flutter/material.dart';
import '../../settings/screens/settings_screen.dart';
import '../../notes/screens/notes_screen.dart';
import '../../about/screens/about_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 45,
                ),

                const SizedBox(height: 15),

                const Text(
                  "Fluxo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Controla tu dinero con cabeza.",
                  style: TextStyle(
                    color: Colors.blueGrey.shade300,
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
                color: Colors.blueGrey.shade500,
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
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
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