import 'package:flutter/material.dart';
import '../../../../data/models/movimiento.dart';

void showDetalleMovimiento(BuildContext context, Movimiento item) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0F172A), // Fondo oscuro coherente
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Línea decorativa superior (Pestaña)
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Etiqueta de Tipo (Ingreso/Gasto)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (item.ingreso ? Colors.greenAccent : Colors.redAccent).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.ingreso ? "INGRESO" : "GASTO",
              style: TextStyle(
                color: item.ingreso ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
          
          const SizedBox(height: 15),

          // Título del movimiento
          Text(
            item.titulo,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Fecha formateada
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                "${item.fecha.day}/${item.fecha.month}/${item.fecha.year}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Divider(height: 50, color: Colors.white10),

          // Fila de Monto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Monto total",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              Text(
                "${item.ingreso ? '+' : '-'}\$${item.monto.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: item.ingreso ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}