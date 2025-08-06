import '../entities/task.dart';
import '../entities/task_category.dart';

/// Abstract repository cho Task
abstract class TaskRepository {
  /// Lấy tất cả nhiệm vụ
  Future<List<Task>> getAllTasks();

  /// Lấy nhiệm vụ theo ngày
  Future<List<Task>> getTasksByDate(DateTime date);

  /// Lấy nhiệm vụ hôm nay
  Future<List<Task>> getTodayTasks();

  /// Lấy nhiệm vụ theo danh mục
  Future<List<Task>> getTasksByCategory(String categoryId);

  /// Lấy nhiệm vụ theo trạng thái
  Future<List<Task>> getTasksByStatus(bool isCompleted);

  /// Lấy nhiệm vụ theo độ ưu tiên
  Future<List<Task>> getTasksByPriority(int priority);

  /// Lấy nhiệm vụ quá hạn
  Future<List<Task>> getOverdueTasks();

  /// Lấy nhiệm vụ sắp đến hạn
  Future<List<Task>> getUpcomingTasks();

  /// Thêm nhiệm vụ mới
  Future<void> addTask(Task task);

  /// Cập nhật nhiệm vụ
  Future<void> updateTask(Task task);

  /// Xóa nhiệm vụ
  Future<void> deleteTask(String taskId);

  /// Toggle trạng thái hoàn thành
  Future<void> toggleTaskCompletion(String taskId);

  /// Lấy thống kê nhiệm vụ
  Future<TaskStats> getTaskStats();

  /// Lấy tất cả danh mục
  Future<List<TaskCategory>> getAllCategories();

  /// Thêm danh mục mới
  Future<void> addCategory(TaskCategory category);

  /// Cập nhật danh mục
  Future<void> updateCategory(TaskCategory category);

  /// Xóa danh mục
  Future<void> deleteCategory(String categoryId);

  /// Tìm kiếm nhiệm vụ
  Future<List<Task>> searchTasks(String query);

  /// Lấy nhiệm vụ theo khoảng thời gian
  Future<List<Task>> getTasksInDateRange(DateTime startDate, DateTime endDate);

  /// Sao lưu dữ liệu
  Future<void> backupTasks();

  /// Khôi phục dữ liệu
  Future<void> restoreTasks();

  /// Lấy micro tasks hàng ngày
  Future<List<Task>> getDailyMicroTasks();
}

/// Class thống kê nhiệm vụ
class TaskStats {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;
  final int todayTasks;
  final int todayCompletedTasks;
  final double completionRate;
  final Map<String, int> categoryStats;
  final Map<int, int> priorityStats;

  const TaskStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    required this.todayTasks,
    required this.todayCompletedTasks,
    required this.completionRate,
    required this.categoryStats,
    required this.priorityStats,
  });

  /// Tỷ lệ hoàn thành hôm nay
  double get todayCompletionRate {
    if (todayTasks == 0) return 0.0;
    return (todayCompletedTasks / todayTasks) * 100;
  }

  /// Số nhiệm vụ còn lại hôm nay
  int get todayRemainingTasks {
    return todayTasks - todayCompletedTasks;
  }
}
