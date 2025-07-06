import 'package:flutter/material.dart';
import 'package:mental_health/core/theme.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: DefaultColors.white.withAlpha(50),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_drop_down,
            color: DefaultColors.reverseTextPrimary,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_outline,
            color: DefaultColors.reverseTextPrimary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
