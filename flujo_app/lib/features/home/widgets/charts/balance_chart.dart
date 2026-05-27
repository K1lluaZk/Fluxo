import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BalanceChart extends StatelessWidget {
  final double ingresos;
  final double gastos;

  const BalanceChart({
    super.key,
    required this.ingresos,
    required this.gastos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260, // 1. Aumentamos la altura de la tarjeta para albergar el gráfico más grande
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Flexible(
            child: Text(
              "Resumen\nfinanciero",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 15),

          // 2. Aumentamos el tamaño de la caja de 140x140 a 200x200
          SizedBox(
            width: 200,
            height: 200,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 270,
                centerSpaceRadius: 40, // 3. Espacio del centro (un poco más grande para dar balance)
                sectionsSpace: 4,
                sections: [
                  PieChartSectionData(
                    value: ingresos,
                    title: "Ingresos",
                    radius: 55, // 4. Aumentamos el grosor de la rebanada (antes era 35)
                    color: const Color(0xFF4ADE80),
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13, // 5. Letra un poco más grande y legible
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: gastos,
                    title: "Gastos",
                    radius: 55, // 4. Mismo grosor aquí
                    color: const Color(0xFFF87171),
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}