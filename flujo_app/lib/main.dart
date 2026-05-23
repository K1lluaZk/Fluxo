import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/home/screens/home_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('movimientos_box');

  runApp(const FluxoApp());
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