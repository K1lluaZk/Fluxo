import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/movimiento.dart'; 
import 'data/models/note.dart';
import 'features/home/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/home/providers/movimiento_provider.dart';
import 'features/notes/providers/note_provider.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovimientoAdapter());
  Hive.registerAdapter(NoteAdapter());
  
  await Hive.openBox<Movimiento>('movimientos_box');
  await Hive.openBox<Note>('notes_box');
  await Hive.openBox("settings");
  

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MovimientoProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NoteProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
      ),
    ],
    child: const FluxoApp(),
  ),
);

}

class FluxoApp extends StatelessWidget {
  const FluxoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluxo',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: settings.modoOscuro
          ? ThemeMode.dark
          : ThemeMode.light,

      home: const HomeScreen(),
    );
  }
}
