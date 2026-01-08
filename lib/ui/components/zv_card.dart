import 'package:flutter/material.dart';
import '../theme/zv_colors.dart';

class ZVCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const ZVCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);

    // ✅ Material + Ink: ombra, border e ripple sono coerenti e clippati
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      elevation: 0,
      child: Ink(
        decoration: BoxDecoration(
          color: ZVColors.card,
          borderRadius: radius,
          border: Border.all(
            color: ZVColors.border.withValues(alpha: 0.6),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              offset: Offset(0, 10),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: ZVColors.primary.withValues(alpha: 0.12),
          highlightColor: ZVColors.primary.withValues(alpha: 0.06),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
