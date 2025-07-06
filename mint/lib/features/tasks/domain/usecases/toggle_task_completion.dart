import '../repositories/task_repository.dart';

/// Use case để toggle trạng thái hoàn thành nhiệm vụ
class ToggleTaskCompletion {
  final TaskRepository repository;

  ToggleTaskCompletion(this.repository);

  /// Toggle trạng thái hoàn thành của nhiệm vụ
  Future<void> call(String taskId) async {
    try {
      await repository.toggleTaskCompletion(taskId);
    } catch (e) {
      throw Exception('Không thể cập nhật trạng thái nhiệm vụ: $e');
    }
  }
}
