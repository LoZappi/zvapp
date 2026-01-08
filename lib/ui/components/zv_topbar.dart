import 'package:flutter/material.dart';
import '../theme/zv_colors.dart';

class ZVTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;

  const ZVTopBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 74,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: ZVColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_shipping, color: ZVColors.textPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(8),
        child: Container(
          height: 8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [ZVColors.primary, Color(0xFFFFE07A)]),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(82);
}
