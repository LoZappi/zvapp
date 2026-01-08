import 'package:flutter/material.dart';
import '../theme/zv_colors.dart';
import 'zv_card.dart';

class ZVStepBar extends StatelessWidget {
  final int step; // 1..total
  final int total;
  final String label;

  const ZVStepBar({super.key, required this.step, required this.total, required this.label});

  @override
  Widget build(BuildContext context) {
    final pct = (step / total).clamp(0.0, 1.0);
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 10,
              backgroundColor: const Color(0x14000000),
              valueColor: AlwaysStoppedAnimation(ZVColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text('Schritt $step von $total', style: TextStyle(color: ZVColors.textSecondary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
