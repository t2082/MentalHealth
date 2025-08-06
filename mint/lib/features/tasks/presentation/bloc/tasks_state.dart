import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import 'tasks_event.dart';

/// Base class cho tất cả Task states
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

/// State ban đầu
class TasksInitial extends TasksState {
  const TasksInitial();
}

/// State đang loading
class TasksLoading extends TasksState {
  const TasksLoading();
}

/// State đã load thành công
class TasksLoaded extends TasksState {
  final List<Task> tasks;
  final List<Task> microTasks;
  final TaskStats? stats;
  final TaskFilter currentFilter;
  final TaskSortOrder currentSort;
  final String? searchQuery;

  const TasksLoaded({
    required this.tasks,
    this.microTasks = const [],
    this.stats,
    this.currentFilter = TaskFilter.all,
    this.currentSort = TaskSortOrder.createdDateDesc,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        tasks,
        microTasks,
        stats,
        currentFilter,
        currentSort,
        searchQuery,
      ];

  /// Tạo bản sao với các thuộc tính được cập nhật
  TasksLoaded copyWith({
    List<Task>? tasks,
    List<Task>? microTasks,
    TaskStats? stats,
    TaskFilter? currentFilter,
    TaskSortOrder? currentSort,
    String? searchQuery,
  }) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
      microTasks: microTasks ?? this.microTasks,
      stats: stats ?? this.stats,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Lấy nhiệm vụ đã được filter và sort
  List<Task> get filteredAndSortedTasks {
    List<Task> filtered = List.from(tasks);

    // Apply filter
    switch (currentFilter) {
      case TaskFilter.completed:
        filtered = filtered.where((task) => task.isCompleted).toList();
        break;
      case TaskFilter.pending:
        filtered = filtered.where((task) => !task.isCompleted).toList();
        break;
      case TaskFilter.overdue:
        filtered = filtered.where((task) => task.isOverdue).toList();
        break;
      case TaskFilter.today:
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        filtered = filtered.where((task) {
          return task.createdAt.isAfter(startOfDay) && 
                 task.createdAt.isBefore(endOfDay);
        }).toList();
        break;
      case TaskFilter.upcoming:
        filtered = filtered.where((task) => task.isDueSoon).toList();
        break;
      case TaskFilter.all:
      default:
        // Không filter
        break;
    }

    // Apply search
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final lowercaseQuery = searchQuery!.toLowerCase();
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
               task.description.toLowerCase().contains(lowercaseQuery) ||
               task.category.name.toLowerCase().contains(lowercaseQuery);
      }).toList();
    }

    // Apply sort
    switch (currentSort) {
      case TaskSortOrder.createdDateAsc:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TaskSortOrder.createdDateDesc:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSortOrder.priorityAsc:
        filtered.sort((a, b) => a.priority.compareTo(b.priority));
        break;
      case TaskSortOrder.priorityDesc:
        filtered.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case TaskSortOrder.dueDateAsc:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOrder.dueDateDesc:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return b.dueDate!.compareTo(a.dueDate!);
        });
        break;
      case TaskSortOrder.titleAsc:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TaskSortOrder.titleDesc:
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
    }

    return filtered;
  }

  /// Lấy số lượng nhiệm vụ theo từng trạng thái
  int get completedCount => tasks.where((task) => task.isCompleted).length;
  int get pendingCount => tasks.where((task) => !task.isCompleted).length;
  int get overdueCount => tasks.where((task) => task.isOverdue).length;
  int get todayCount {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return tasks.where((task) {
      return task.createdAt.isAfter(startOfDay) && 
             task.createdAt.isBefore(endOfDay);
    }).length;
  }
}

/// State lỗi
class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State đang thực hiện action (add, update, delete)
class TasksActionInProgress extends TasksState {
  final String message;

  const TasksActionInProgress(this.message);

  @override
  List<Object?> get props => [message];
}

/// State action thành công
class TasksActionSuccess extends TasksState {
  final String message;

  const TasksActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State action thất bại
class TasksActionFailure extends TasksState {
  final String message;

  const TasksActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
