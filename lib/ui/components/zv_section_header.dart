import 'package:flutter/material.dart';

import '../theme/zv_colors.dart';
import 'zv_card.dart';

class ZVSectionHeader extends StatelessWidget {
  final String? badge;
  final String title;
  final String? subtitle;

  const ZVSectionHeader({
    super.key,
    this.badge,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ZVCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (badge != null) ...[
            ZVBadge(text: badge!),
            const SizedBox(height: 12),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: ZVColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ZVColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ZVBadge extends StatelessWidget {
  final String text;
  const ZVBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ZVColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: ZVColors.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: ZVColors.textPrimary,
        ),
      ),
    );
  }
}
