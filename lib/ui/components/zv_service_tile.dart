import 'package:flutter/material.dart';
import '../theme/zv_colors.dart';
import 'zv_card.dart';

class ZVServiceTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const ZVServiceTile({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: selected ? ZVColors.primary : const Color(0x14FFD200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: ZVColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
          if (selected) Icon(Icons.check_circle, color: ZVColors.textPrimary) else const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
