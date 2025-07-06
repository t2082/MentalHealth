import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/repositories/task_repository.dart';

/// Widget hiển thị thống kê nhiệm vụ
class TaskStatsCard extends StatelessWidget {
  final TaskStats stats;
  final VoidCallback? onTap;

  const TaskStatsCard({
    super.key,
    required this.stats,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _buildProgressBar(context),
        Text(
          'Hoàn thành ${stats.todayCompletedTasks}/${stats.todayTasks} nhiệm vụ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        _buildStatsRow(context),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            stats.todayCompletedTasks.toString(),
            'Hoàn thành',
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            stats.todayRemainingTasks.toString(),
            'Còn lại',
            Icons.schedule_outlined,
            Colors.orange,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            context,
            stats.overdueTasks.toString(),
            'Quá hạn',
            Icons.warning_outlined,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black38,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: color,
          width: 2.5,
        ),
        gradient: RadialGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.7),
          ],
          center: Alignment.topLeft,
          radius: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 5),
              Icon(
                icon,
                color: color,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    // final progress = stats.todayTasks > 0
    //     ? stats.todayCompletedTasks / stats.todayTasks
    //     : 0.0;
    final progress = 0.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ hôm nay',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getCompletionColor(),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_getCompletionColor()),
            ),
          ),
        ),
      ],
    );
  }

  Color _getCompletionColor() {
    final rate = stats.todayCompletionRate;
    if (rate >= 80) return Colors.green;
    if (rate >= 50) return Colors.orange;
    return Colors.red;
  }
}
