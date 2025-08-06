import '../../domain/entities/task.dart';
import '../../domain/entities/task_category.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';
import '../models/task_model.dart';

/// Implementation của TaskRepository
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final taskModels = await localDataSource.getAllTasks();
      return taskModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy tất cả nhiệm vụ: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByDate(DateTime date) async {
    try {
      final allTasks = await getAllTasks();
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      return allTasks.where((task) {
        return task.createdAt.isAfter(startOfDay) && 
               task.createdAt.isBefore(endOfDay);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo ngày: $e');
    }
  }

  @override
  Future<List<Task>> getTodayTasks() async {
    try {
      return await getTasksByDate(DateTime.now());
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ hôm nay: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByCategory(String categoryId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.category.id == categoryId).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo danh mục: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByStatus(bool isCompleted) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.isCompleted == isCompleted).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo trạng thái: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByPriority(int priority) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.priority == priority).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo độ ưu tiên: $e');
    }
  }

  @override
  Future<List<Task>> getOverdueTasks() async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.isOverdue).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ quá hạn: $e');
    }
  }

  @override
  Future<List<Task>> getUpcomingTasks() async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.isDueSoon).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ sắp đến hạn: $e');
    }
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.addTask(taskModel);
    } catch (e) {
      throw Exception('Lỗi khi thêm nhiệm vụ: $e');
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.updateTask(taskModel);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật nhiệm vụ: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await localDataSource.deleteTask(taskId);
    } catch (e) {
      throw Exception('Lỗi khi xóa nhiệm vụ: $e');
    }
  }

  @override
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      await localDataSource.toggleTaskCompletion(taskId);
    } catch (e) {
      throw Exception('Lỗi khi toggle trạng thái nhiệm vụ: $e');
    }
  }

  @override
  Future<TaskStats> getTaskStats() async {
    try {
      final allTasks = await getAllTasks();
      final todayTasks = await getTodayTasks();
      
      final totalTasks = allTasks.length;
      final completedTasks = allTasks.where((task) => task.isCompleted).length;
      final pendingTasks = totalTasks - completedTasks;
      final overdueTasks = allTasks.where((task) => task.isOverdue).length;
      
      final todayTasksCount = todayTasks.length;
      final todayCompletedTasks = todayTasks.where((task) => task.isCompleted).length;
      
      final completionRate = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;
      
      // Thống kê theo danh mục
      final categoryStats = <String, int>{};
      for (final task in allTasks) {
        categoryStats[task.category.id] = (categoryStats[task.category.id] ?? 0) + 1;
      }
      
      // Thống kê theo độ ưu tiên
      final priorityStats = <int, int>{};
      for (final task in allTasks) {
        priorityStats[task.priority] = (priorityStats[task.priority] ?? 0) + 1;
      }
      
      return TaskStats(
        totalTasks: totalTasks,
        completedTasks: completedTasks,
        pendingTasks: pendingTasks,
        overdueTasks: overdueTasks,
        todayTasks: todayTasksCount,
        todayCompletedTasks: todayCompletedTasks,
        completionRate: completionRate,
        categoryStats: categoryStats,
        priorityStats: priorityStats,
      );
    } catch (e) {
      throw Exception('Lỗi khi lấy thống kê nhiệm vụ: $e');
    }
  }

  @override
  Future<List<TaskCategory>> getAllCategories() async {
    try {
      final categoryModels = await localDataSource.getAllCategories();
      return categoryModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy tất cả danh mục: $e');
    }
  }

  @override
  Future<void> addCategory(TaskCategory category) async {
    try {
      final categories = await localDataSource.getAllCategories();
      final categoryModel = TaskCategoryModel.fromEntity(category);
      categories.add(categoryModel);
      await localDataSource.saveCategories(categories);
    } catch (e) {
      throw Exception('Lỗi khi thêm danh mục: $e');
    }
  }

  @override
  Future<void> updateCategory(TaskCategory category) async {
    try {
      final categories = await localDataSource.getAllCategories();
      final index = categories.indexWhere((c) => c.id == category.id);
      
      if (index == -1) {
        throw Exception('Không tìm thấy danh mục để cập nhật');
      }
      
      categories[index] = TaskCategoryModel.fromEntity(category);
      await localDataSource.saveCategories(categories);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật danh mục: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      final categories = await localDataSource.getAllCategories();
      categories.removeWhere((category) => category.id == categoryId);
      await localDataSource.saveCategories(categories);
    } catch (e) {
      throw Exception('Lỗi khi xóa danh mục: $e');
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      final allTasks = await getAllTasks();
      final lowercaseQuery = query.toLowerCase();
      
      return allTasks.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
               task.description.toLowerCase().contains(lowercaseQuery) ||
               task.category.name.toLowerCase().contains(lowercaseQuery) ||
               task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm nhiệm vụ: $e');
    }
  }

  @override
  Future<List<Task>> getTasksInDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) {
        return task.createdAt.isAfter(startDate) && 
               task.createdAt.isBefore(endDate);
      }).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo khoảng thời gian: $e');
    }
  }

  @override
  Future<void> backupTasks() async {
    try {
      // TODO: Implement backup functionality
      throw UnimplementedError('Chức năng sao lưu chưa được triển khai');
    } catch (e) {
      throw Exception('Lỗi khi sao lưu dữ liệu: $e');
    }
  }

  @override
  Future<void> restoreTasks() async {
    try {
      // TODO: Implement restore functionality
      throw UnimplementedError('Chức năng khôi phục chưa được triển khai');
    } catch (e) {
      throw Exception('Lỗi khi khôi phục dữ liệu: $e');
    }
  }

  @override
  Future<List<Task>> getDailyMicroTasks() async {
    try {
      final microTaskModels = await localDataSource.getDailyMicroTasks();
      return microTaskModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy micro tasks hàng ngày: $e');
    }
  }
}
