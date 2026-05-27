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
      height: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumen financiero",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 45,
                sectionsSpace: 4,
                sections: [
                  PieChartSectionData(
                    value: ingresos,
                    title: "Ingresos",
                    radius: 55,
                    color: const Color(0xFF4ADE80),
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  PieChartSectionData(
                    value: gastos,
                    title: "Gastos",
                    radius: 55,
                    color: const Color(0xFFF87171),
                    titleStyle: const TextStyle(
                      color: Colors.white,
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