import '../repositories/task_repository.dart';

/// Use case để lấy thống kê nhiệm vụ
class GetTaskStats {
  final TaskRepository repository;

  GetTaskStats(this.repository);

  /// Lấy thống kê tổng quan
  Future<TaskStats> call() async {
    try {
      return await repository.getTaskStats();
    } catch (e) {
      throw Exception('Không thể lấy thống kê nhiệm vụ: $e');
    }
  }

  /// Lấy thống kê theo khoảng thời gian
  Future<TaskStats> callForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final tasks = await repository.getTasksInDateRange(startDate, endDate);
      
      final totalTasks = tasks.length;
      final completedTasks = tasks.where((task) => task.isCompleted).length;
      final pendingTasks = totalTasks - completedTasks;
      final overdueTasks = tasks.where((task) => task.isOverdue).length;
      
      final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;
      
      // Thống kê theo danh mục
      final categoryStats = <String, int>{};
      for (final task in tasks) {
        categoryStats[task.category.id] = (categoryStats[task.category.id] ?? 0) + 1;
      }
      
      // Thống kê theo độ ưu tiên
      final priorityStats = <int, int>{};
      for (final task in tasks) {
        priorityStats[task.priority] = (priorityStats[task.priority] ?? 0) + 1;
      }
      
      return TaskStats(
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        pendingTasks: pendingTasks,
        overdueTasks: overdueTasks,
        todayTasks: 0, // Không áp dụng cho khoảng thời gian
        todayCompletedTasks: 0,
        completionRate: completionRate,
        categoryStats: categoryStats,
        priorityStats: priorityStats,
      );
    } catch (e) {
      throw Exception('Không thể lấy thống kê theo khoảng thời gian: $e');
    }
  }
}
