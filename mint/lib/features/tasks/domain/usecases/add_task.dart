import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Use case để thêm nhiệm vụ mới
class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  /// Thêm nhiệm vụ mới
  Future<void> call(Task task) async {
    try {
      // Validate dữ liệu đầu vào
      if (task.title.trim().isEmpty) {
        throw Exception('Tên nhiệm vụ không được để trống');
      }

      if (task.description.trim().isEmpty) {
        throw Exception('Mô tả nhiệm vụ không được để trống');
      }

      if (task.priority < 1 || task.priority > 3) {
        throw Exception('Độ ưu tiên phải từ 1 đến 3');
      }

      if (task.estimatedMinutes <= 0) {
        throw Exception('Thời gian ước tính phải lớn hơn 0');
      }

      // Kiểm tra ngày hết hạn
      if (task.dueDate != null && task.dueDate!.isBefore(DateTime.now())) {
        throw Exception('Ngày hết hạn không thể là quá khứ');
      }

      await repository.addTask(task);
    } catch (e) {
      throw Exception('Không thể thêm nhiệm vụ: $e');
    }
  }

  /// Thêm nhiệm vụ nhanh với thông tin cơ bản
  Future<void> callQuick({
    required String title,
    required String description,
    required String categoryId,
    int priority = 2,
    int estimatedMinutes = 30,
  }) async {
    try {
      // Lấy danh mục từ repository
      final categories = await repository.getAllCategories();
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Không tìm thấy danh mục'),
      );

      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        category: category,
        createdAt: DateTime.now(),
        priority: priority,
        estimatedMinutes: estimatedMinutes,
      );

      await call(task);
    } catch (e) {
      throw Exception('Không thể thêm nhiệm vụ nhanh: $e');
    }
  }
}
