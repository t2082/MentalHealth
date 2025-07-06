import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../domain/entities/task.dart';
import 'task_category_chip.dart';

/// Widget hiển thị một item nhiệm vụ
class TaskItemCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleCompletion;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showCategory;
  final bool showPriority;
  final bool showDueDate;

  const TaskItemCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleCompletion,
    this.onEdit,
    this.onDelete,
    this.showCategory = true,
    this.showPriority = true,
    this.showDueDate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(task.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Sửa',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Xóa',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        color: Colors.black.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: task.isCompleted 
                ? Colors.green.withOpacity(0.3)
                : task.category.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  task.category.color.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildContent(context),
                if (_shouldShowMetadata()) ...[
                  const SizedBox(height: 12),
                  _buildMetadata(context),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onToggleCompletion,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: task.isCompleted ? Colors.green : Colors.white54,
                width: 2,
              ),
              color: task.isCompleted 
                  ? Colors.green 
                  : Colors.transparent,
            ),
            child: task.isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            task.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: task.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
              decorationColor: Colors.white54,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showPriority) _buildPriorityIndicator(),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      task.description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white70,
        decoration: task.isCompleted 
            ? TextDecoration.lineThrough 
            : null,
        decorationColor: Colors.white54,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (showCategory)
          TaskCategoryChip(category: task.category),
        if (showDueDate && task.dueDate != null)
          _buildDueDateChip(context),
        if (task.estimatedMinutes > 0)
          _buildTimeChip(context),
        if (task.tags.isNotEmpty)
          ...task.tags.take(2).map((tag) => _buildTagChip(context, tag)),
      ],
    );
  }

  Widget _buildPriorityIndicator() {
    Color color;
    switch (task.priority) {
      case 3:
        color = Colors.red;
        break;
      case 2:
        color = Colors.orange;
        break;
      case 1:
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 8,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
    final isOverdue = task.isOverdue;
    final isDueSoon = task.isDueSoon;
    
    Color backgroundColor;
    Color textColor;
    IconData icon;
    
    if (isOverdue) {
      backgroundColor = Colors.red.withOpacity(0.2);
      textColor = Colors.red;
      icon = Icons.warning_outlined;
    } else if (isDueSoon) {
      backgroundColor = Colors.orange.withOpacity(0.2);
      textColor = Colors.orange;
      icon = Icons.schedule_outlined;
    } else {
      backgroundColor = Colors.blue.withOpacity(0.2);
      textColor = Colors.blue;
      icon = Icons.calendar_today_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(),
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 12, color: Colors.purple),
          const SizedBox(width: 4),
          Text(
            '${task.estimatedMinutes}p',
            style: const TextStyle(
              color: Colors.purple,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _shouldShowMetadata() {
    return showCategory ||
           (showDueDate && task.dueDate != null) ||
           task.estimatedMinutes > 0 ||
           task.tags.isNotEmpty;
  }

  String _formatDueDate() {
    if (task.dueDate == null) return '';
    
    final now = DateTime.now();
    final dueDate = task.dueDate!;
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    if (difference == -1) return 'Hôm qua';
    if (difference < 0) return '${-difference} ngày trước';
    return '$difference ngày nữa';
  }
}
