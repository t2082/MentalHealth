import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_daily_tasks.dart';
import '../../domain/usecases/add_task.dart' as add_task_uc;
import '../../domain/usecases/delete_task.dart' as delete_task_uc;
import '../../domain/usecases/toggle_task_completion.dart' as toggle_task_uc;
import '../../domain/usecases/get_task_stats.dart';
import '../../domain/repositories/task_repository.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

/// BLoC quản lý state của Tasks
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final GetDailyTasks getDailyTasks;
  final add_task_uc.AddTask addTaskUseCase;
  final delete_task_uc.DeleteTask deleteTaskUseCase;
  final toggle_task_uc.ToggleTaskCompletion toggleTaskCompletionUseCase;
  final GetTaskStats getTaskStats;
  final TaskRepository taskRepository;

  TasksBloc({
    required this.getDailyTasks,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskCompletionUseCase,
    required this.getTaskStats,
    required this.taskRepository,
  }) : super(const TasksInitial()) {
    on<LoadTodayTasks>(_onLoadTodayTasks);
    on<LoadTasksByDate>(_onLoadTasksByDate);
    on<LoadTasksByCategory>(_onLoadTasksByCategory);
    on<LoadTaskStats>(_onLoadTaskStats);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<SearchTasks>(_onSearchTasks);
    on<LoadOverdueTasks>(_onLoadOverdueTasks);
    on<LoadUpcomingTasks>(_onLoadUpcomingTasks);
    on<RefreshTasks>(_onRefreshTasks);
    on<DeleteMultipleTasks>(_onDeleteMultipleTasks);
    on<DeleteCompletedTasks>(_onDeleteCompletedTasks);
    on<ChangeTaskFilter>(_onChangeTaskFilter);
    on<ChangeTaskSort>(_onChangeTaskSort);
    on<LoadDailyMicroTasks>(_onLoadDailyMicroTasks);
  }

  /// Load nhiệm vụ hôm nay
  Future<void> _onLoadTodayTasks(
    LoadTodayTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getDailyTasks();
      final stats = await getTaskStats();
      emit(TasksLoaded(tasks: tasks, stats: stats));
    } catch (e) {
      emit(TasksError('Không thể tải nhiệm vụ hôm nay: ${e.toString()}'));
    }
  }

  /// Load nhiệm vụ theo ngày
  Future<void> _onLoadTasksByDate(
    LoadTasksByDate event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getDailyTasks.callForDate(event.date);
      final stats = await getTaskStats();
      emit(TasksLoaded(tasks: tasks, stats: stats));
    } catch (e) {
      emit(TasksError('Không thể tải nhiệm vụ theo ngày: ${e.toString()}'));
    }
  }

  /// Load nhiệm vụ theo danh mục
  Future<void> _onLoadTasksByCategory(
    LoadTasksByCategory event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getDailyTasks.callByCategory(event.categoryId);
      final stats = await getTaskStats();
      emit(TasksLoaded(tasks: tasks, stats: stats));
    } catch (e) {
      emit(TasksError('Không thể tải nhiệm vụ theo danh mục: ${e.toString()}'));
    }
  }

  /// Load thống kê
  Future<void> _onLoadTaskStats(
    LoadTaskStats event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final stats = await getTaskStats();
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        emit(currentState.copyWith(stats: stats));
      }
    } catch (e) {
      emit(TasksError('Không thể tải thống kê: ${e.toString()}'));
    }
  }

  /// Thêm nhiệm vụ
  Future<void> _onAddTask(
    AddTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksActionInProgress('Đang thêm nhiệm vụ...'));
    try {
      await addTaskUseCase(event.task);
      emit(const TasksActionSuccess('Đã thêm nhiệm vụ thành công!'));

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksActionFailure('Không thể thêm nhiệm vụ: ${e.toString()}'));
    }
  }

  /// Cập nhật nhiệm vụ
  Future<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksActionInProgress('Đang cập nhật nhiệm vụ...'));
    try {
      await taskRepository.updateTask(event.task);
      emit(const TasksActionSuccess('Đã cập nhật nhiệm vụ thành công!'));

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksActionFailure('Không thể cập nhật nhiệm vụ: ${e.toString()}'));
    }
  }

  /// Xóa nhiệm vụ
  Future<void> _onDeleteTask(
    DeleteTask event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksActionInProgress('Đang xóa nhiệm vụ...'));
    try {
      await deleteTaskUseCase(event.taskId);
      emit(const TasksActionSuccess('Đã xóa nhiệm vụ thành công!'));

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksActionFailure('Không thể xóa nhiệm vụ: ${e.toString()}'));
    }
  }

  /// Toggle trạng thái hoàn thành
  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await toggleTaskCompletionUseCase(event.taskId);

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksError('Không thể cập nhật trạng thái: ${e.toString()}'));
    }
  }

  /// Tìm kiếm nhiệm vụ
  Future<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  /// Load nhiệm vụ quá hạn
  Future<void> _onLoadOverdueTasks(
    LoadOverdueTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getDailyTasks.getOverdueTasks();
      final stats = await getTaskStats();
      emit(TasksLoaded(
        tasks: tasks,
        stats: stats,
        currentFilter: TaskFilter.overdue,
      ));
    } catch (e) {
      emit(TasksError('Không thể tải nhiệm vụ quá hạn: ${e.toString()}'));
    }
  }

  /// Load nhiệm vụ sắp đến hạn
  Future<void> _onLoadUpcomingTasks(
    LoadUpcomingTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksLoading());
    try {
      final tasks = await getDailyTasks.getUpcomingTasks();
      final stats = await getTaskStats();
      emit(TasksLoaded(
        tasks: tasks,
        stats: stats,
        currentFilter: TaskFilter.upcoming,
      ));
    } catch (e) {
      emit(TasksError('Không thể tải nhiệm vụ sắp đến hạn: ${e.toString()}'));
    }
  }

  /// Refresh dữ liệu
  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TasksState> emit,
  ) async {
    add(const LoadTodayTasks());
  }

  /// Xóa nhiều nhiệm vụ
  Future<void> _onDeleteMultipleTasks(
    DeleteMultipleTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksActionInProgress('Đang xóa nhiệm vụ...'));
    try {
      await deleteTaskUseCase.callMultiple(event.taskIds);
      emit(const TasksActionSuccess('Đã xóa nhiệm vụ thành công!'));

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksActionFailure('Không thể xóa nhiệm vụ: ${e.toString()}'));
    }
  }

  /// Xóa tất cả nhiệm vụ đã hoàn thành
  Future<void> _onDeleteCompletedTasks(
    DeleteCompletedTasks event,
    Emitter<TasksState> emit,
  ) async {
    emit(const TasksActionInProgress('Đang xóa nhiệm vụ đã hoàn thành...'));
    try {
      await deleteTaskUseCase.deleteCompletedTasks();
      emit(const TasksActionSuccess('Đã xóa tất cả nhiệm vụ đã hoàn thành!'));

      // Reload tasks
      add(const LoadTodayTasks());
    } catch (e) {
      emit(TasksActionFailure(
          'Không thể xóa nhiệm vụ đã hoàn thành: ${e.toString()}'));
    }
  }

  /// Thay đổi filter
  Future<void> _onChangeTaskFilter(
    ChangeTaskFilter event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      emit(currentState.copyWith(currentFilter: event.filter));
    }
  }

  /// Thay đổi sort order
  Future<void> _onChangeTaskSort(
    ChangeTaskSort event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      emit(currentState.copyWith(currentSort: event.sortOrder));
    }
  }

  /// Load micro tasks hàng ngày
  Future<void> _onLoadDailyMicroTasks(
    LoadDailyMicroTasks event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final microTasks = await taskRepository.getDailyMicroTasks();

      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        // Cập nhật micro tasks riêng biệt
        emit(currentState.copyWith(microTasks: microTasks));
      } else {
        // Nếu chưa có state loaded, tạo state mới với micro tasks
        final stats = await getTaskStats();
        emit(TasksLoaded(tasks: const [], microTasks: microTasks, stats: stats));
      }
    } catch (e) {
      emit(TasksError('Không thể tải micro tasks: ${e.toString()}'));
    }
  }
}
