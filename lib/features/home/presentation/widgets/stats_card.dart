import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onPrimary, size: 22),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
