import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/movimiento.dart'; 
import 'data/models/note.dart';
import 'features/home/screens/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'features/home/providers/movimiento_provider.dart';
import 'features/notes/providers/note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MovimientoAdapter());
  Hive.registerAdapter(NoteAdapter());
  
  await Hive.openBox<Movimiento>('movimientos_box');
  await Hive.openBox<Note>('notes_box');
  

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MovimientoProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NoteProvider(),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fluxo',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
