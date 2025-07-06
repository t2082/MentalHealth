import '../repositories/task_repository.dart';

/// Use case để xóa nhiệm vụ
class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  /// Xóa nhiệm vụ theo ID
  Future<void> call(String taskId) async {
    try {
      if (taskId.trim().isEmpty) {
        throw Exception('ID nhiệm vụ không hợp lệ');
      }

      await repository.deleteTask(taskId);
    } catch (e) {
      throw Exception('Không thể xóa nhiệm vụ: $e');
    }
  }

  /// Xóa nhiều nhiệm vụ cùng lúc
  Future<void> callMultiple(List<String> taskIds) async {
    try {
      if (taskIds.isEmpty) {
        throw Exception('Danh sách ID nhiệm vụ trống');
      }

      for (final taskId in taskIds) {
        await repository.deleteTask(taskId);
      }
    } catch (e) {
      throw Exception('Không thể xóa nhiều nhiệm vụ: $e');
    }
  }

  /// Xóa tất cả nhiệm vụ đã hoàn thành
  Future<void> deleteCompletedTasks() async {
    try {
      final completedTasks = await repository.getTasksByStatus(true);
      final taskIds = completedTasks.map((task) => task.id).toList();
      
      if (taskIds.isNotEmpty) {
        await callMultiple(taskIds);
      }
    } catch (e) {
      throw Exception('Không thể xóa nhiệm vụ đã hoàn thành: $e');
    }
  }
}
