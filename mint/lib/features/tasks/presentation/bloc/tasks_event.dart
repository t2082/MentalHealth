import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

/// Base class cho tất cả Task events
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

/// Event để load nhiệm vụ hôm nay
class LoadTodayTasks extends TasksEvent {
  const LoadTodayTasks();
}

/// Event để load nhiệm vụ theo ngày
class LoadTasksByDate extends TasksEvent {
  final DateTime date;

  const LoadTasksByDate(this.date);

  @override
  List<Object?> get props => [date];
}

/// Event để load nhiệm vụ theo danh mục
class LoadTasksByCategory extends TasksEvent {
  final String categoryId;

  const LoadTasksByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Event để load micro tasks hàng ngày
class LoadDailyMicroTasks extends TasksEvent {
  const LoadDailyMicroTasks();
}

/// Event để load thống kê nhiệm vụ
class LoadTaskStats extends TasksEvent {
  const LoadTaskStats();
}

/// Event để thêm nhiệm vụ mới
class AddTask extends TasksEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event để cập nhật nhiệm vụ
class UpdateTask extends TasksEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

/// Event để xóa nhiệm vụ
class DeleteTask extends TasksEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event để toggle trạng thái hoàn thành
class ToggleTaskCompletion extends TasksEvent {
  final String taskId;

  const ToggleTaskCompletion(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

/// Event để tìm kiếm nhiệm vụ
class SearchTasks extends TasksEvent {
  final String query;

  const SearchTasks(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event để load nhiệm vụ quá hạn
class LoadOverdueTasks extends TasksEvent {
  const LoadOverdueTasks();
}

/// Event để load nhiệm vụ sắp đến hạn
class LoadUpcomingTasks extends TasksEvent {
  const LoadUpcomingTasks();
}

/// Event để refresh dữ liệu
class RefreshTasks extends TasksEvent {
  const RefreshTasks();
}

/// Event để xóa nhiều nhiệm vụ
class DeleteMultipleTasks extends TasksEvent {
  final List<String> taskIds;

  const DeleteMultipleTasks(this.taskIds);

  @override
  List<Object?> get props => [taskIds];
}

/// Event để xóa tất cả nhiệm vụ đã hoàn thành
class DeleteCompletedTasks extends TasksEvent {
  const DeleteCompletedTasks();
}

/// Event để thay đổi filter
class ChangeTaskFilter extends TasksEvent {
  final TaskFilter filter;

  const ChangeTaskFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Event để thay đổi sort order
class ChangeTaskSort extends TasksEvent {
  final TaskSortOrder sortOrder;

  const ChangeTaskSort(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}

/// Enum cho filter options
enum TaskFilter {
  all,
  completed,
  pending,
  overdue,
  today,
  upcoming,
}

/// Enum cho sort options
enum TaskSortOrder {
  createdDateAsc,
  createdDateDesc,
  priorityAsc,
  priorityDesc,
  dueDateAsc,
  dueDateDesc,
  titleAsc,
  titleDesc,
}
