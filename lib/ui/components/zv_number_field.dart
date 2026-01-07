import 'package:flutter/material.dart';
import '../../theme/zv_theme.dart';
import 'zv_card.dart';

class ZVNumberField extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const ZVNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))),
          IconButton(
            onPressed: () => onChanged((value - 1).clamp(min, max)),
            icon: const Icon(Icons.remove),
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.w900)),
          IconButton(
            onPressed: () => onChanged((value + 1).clamp(min, max)),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
