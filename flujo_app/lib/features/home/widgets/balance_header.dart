import 'package:flutter/material.dart';

class BalanceHeader extends StatelessWidget {

  final double balance;

  const BalanceHeader({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Balance Total",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "\$${balance.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}