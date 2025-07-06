import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case để lấy nhiệm vụ hàng ngày
class GetDailyTasks {
  final TaskRepository repository;

  GetDailyTasks(this.repository);

  /// Lấy nhiệm vụ hôm nay
  Future<List<Task>> call() async {
    try {
      final tasks = await repository.getTodayTasks();
      
      // Sắp xếp theo độ ưu tiên và trạng thái
      tasks.sort((a, b) {
        // Nhiệm vụ chưa hoàn thành lên trước
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        
        // Sắp xếp theo độ ưu tiên (cao -> thấp)
        if (a.priority != b.priority) {
          return b.priority.compareTo(a.priority);
        }
        
        // Sắp xếp theo thời gian tạo (mới -> cũ)
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return tasks;
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhiệm vụ hôm nay: $e');
    }
  }

  /// Lấy nhiệm vụ theo ngày cụ thể
  Future<List<Task>> callForDate(DateTime date) async {
    try {
      final tasks = await repository.getTasksByDate(date);
      
      // Sắp xếp tương tự như trên
      tasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        if (a.priority != b.priority) {
          return b.priority.compareTo(a.priority);
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return tasks;
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhiệm vụ cho ngày ${date.toString()}: $e');
    }
  }

  /// Lấy nhiệm vụ theo danh mục
  Future<List<Task>> callByCategory(String categoryId) async {
    try {
      final tasks = await repository.getTasksByCategory(categoryId);
      
      tasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        if (a.priority != b.priority) {
          return b.priority.compareTo(a.priority);
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return tasks;
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhiệm vụ theo danh mục: $e');
    }
  }

  /// Lấy nhiệm vụ quá hạn
  Future<List<Task>> getOverdueTasks() async {
    try {
      return await repository.getOverdueTasks();
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhiệm vụ quá hạn: $e');
    }
  }

  /// Lấy nhiệm vụ sắp đến hạn
  Future<List<Task>> getUpcomingTasks() async {
    try {
      return await repository.getUpcomingTasks();
    } catch (e) {
      throw Exception('Không thể lấy danh sách nhiệm vụ sắp đến hạn: $e');
    }
  }
}
