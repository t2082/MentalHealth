import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../../domain/entities/task_category.dart';
import '../demo_data.dart';

/// Local data source cho Task sử dụng SharedPreferences
abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<void> toggleTaskCompletion(String taskId);
  Future<List<TaskCategoryModel>> getAllCategories();
  Future<void> saveCategories(List<TaskCategoryModel> categories);
  Future<void> clearAllData();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String _tasksKey = 'tasks';
  static const String _categoriesKey = 'task_categories';

  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final tasksJson = sharedPreferences.getString(_tasksKey);
      if (tasksJson == null) {
        // Nếu chưa có dữ liệu, tạo demo data
        final demoTasks = TaskDemoData.getDemoTasks()
            .map((task) => TaskModel.fromEntity(task))
            .toList();
        await saveTasks(demoTasks);
        return demoTasks;
      }

      final List<dynamic> tasksList = json.decode(tasksJson);
      return tasksList.map((taskJson) => TaskModel.fromJson(taskJson)).toList();
    } catch (e) {
      throw Exception('Lỗi khi đọc dữ liệu nhiệm vụ: $e');
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final tasksJson =
          json.encode(tasks.map((task) => task.toJson()).toList());
      await sharedPreferences.setString(_tasksKey, tasksJson);
    } catch (e) {
      throw Exception('Lỗi khi lưu dữ liệu nhiệm vụ: $e');
    }
  }

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      final tasks = await getAllTasks();
      tasks.add(task);
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('Lỗi khi thêm nhiệm vụ: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      final tasks = await getAllTasks();
      final index = tasks.indexWhere((t) => t.id == task.id);

      if (index == -1) {
        throw Exception('Không tìm thấy nhiệm vụ để cập nhật');
      }

      tasks[index] = task;
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('Lỗi khi cập nhật nhiệm vụ: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final tasks = await getAllTasks();
      tasks.removeWhere((task) => task.id == taskId);
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('Lỗi khi xóa nhiệm vụ: $e');
    }
  }

  @override
  Future<List<TaskCategoryModel>> getAllCategories() async {
    try {
      final categoriesJson = sharedPreferences.getString(_categoriesKey);

      if (categoriesJson == null) {
        // Nếu chưa có dữ liệu, tạo danh mục mặc định
        final defaultCategories = TaskCategory.defaultCategories
            .map((category) => TaskCategoryModel.fromEntity(category))
            .toList();
        await saveCategories(defaultCategories);
        return defaultCategories;
      }

      final List<dynamic> categoriesList = json.decode(categoriesJson);
      return categoriesList
          .map((categoryJson) => TaskCategoryModel.fromJson(categoryJson))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi đọc dữ liệu danh mục: $e');
    }
  }

  @override
  Future<void> saveCategories(List<TaskCategoryModel> categories) async {
    try {
      final categoriesJson = json.encode(
        categories.map((category) => category.toJson()).toList(),
      );
      await sharedPreferences.setString(_categoriesKey, categoriesJson);
    } catch (e) {
      throw Exception('Lỗi khi lưu dữ liệu danh mục: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await sharedPreferences.remove(_tasksKey);
      await sharedPreferences.remove(_categoriesKey);
    } catch (e) {
      throw Exception('Lỗi khi xóa tất cả dữ liệu: $e');
    }
  }

  /// Lấy nhiệm vụ theo ngày
  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
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

  /// Lấy nhiệm vụ theo danh mục
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.category.id == categoryId).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo danh mục: $e');
    }
  }

  /// Lấy nhiệm vụ theo trạng thái
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.isCompleted == isCompleted).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy nhiệm vụ theo trạng thái: $e');
    }
  }

  /// Toggle trạng thái hoàn thành
  @override
  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final tasks = await getAllTasks();
      final index = tasks.indexWhere((t) => t.id == taskId);

      if (index == -1) {
        throw Exception('Không tìm thấy nhiệm vụ');
      }

      final task = tasks[index];
      final updatedTask = task.isCompleted
          ? task.markAsIncomplete() as TaskModel
          : task.markAsCompleted() as TaskModel;

      tasks[index] = updatedTask;
      await saveTasks(tasks);
    } catch (e) {
      throw Exception('Lỗi khi toggle trạng thái nhiệm vụ: $e');
    }
  }
}
