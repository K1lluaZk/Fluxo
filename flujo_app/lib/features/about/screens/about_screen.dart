import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de Fluxo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Fluxo",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Aplicación personal de control financiero creada en Flutter.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey.shade300,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Versión 1.0",
              style: TextStyle(
                color: Colors.blueGrey.shade500,
              ),
            ),

            Text(
              "Creada por Mario Suero.",
              style: TextStyle(
                color: Colors.blueGrey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}