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
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              "Resumen\nfinanciero",
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 15),

          SizedBox(
            width: 200,
            height: 200,
            child: PieChart(
              PieChartData(
                startDegreeOffset: 270,
                centerSpaceRadius: 40,
                sectionsSpace: 4,
                sections: [
                  PieChartSectionData(
                    value: ingresos,
                    title: "Ingresos",
                    radius: 55,
                    color: colors.secondary,
                    titleStyle: TextStyle(
                      color: colors.onSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    value: gastos,
                    title: "Gastos",
                    radius: 55,
                    color: colors.error,
                    titleStyle: TextStyle(
                      color: colors.onError,
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