import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color accent;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation)),
          child: Opacity(opacity: animation, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: value),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (_, animatedValue, __) {
                      return Text(
                        NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: 'R\$',
                        ).format(animatedValue),
                        style: const TextStyle(
                          color: AppTheme.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
