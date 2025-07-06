import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Domain
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/get_daily_tasks.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/toggle_task_completion.dart';
import 'domain/usecases/get_task_stats.dart';

// Data
import 'data/repositories/task_repository_impl.dart';
import 'data/datasources/task_local_datasource.dart';

// Presentation
import 'presentation/bloc/tasks_bloc.dart';

final sl = GetIt.instance;

/// Khởi tạo dependency injection cho Tasks feature
Future<void> initTasksFeature() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDailyTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompletion(sl()));
  sl.registerLazySingleton(() => GetTaskStats(sl()));

  // BLoC
  sl.registerFactory(
    () => TasksBloc(
      getDailyTasks: sl(),
      addTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
      toggleTaskCompletionUseCase: sl(),
      getTaskStats: sl(),
      taskRepository: sl(),
    ),
  );
}
