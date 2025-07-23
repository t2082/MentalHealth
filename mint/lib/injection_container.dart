import 'package:get_it/get_it.dart';
import 'package:mental_health/core/services/firebase_service.dart';
import 'package:mental_health/core/services/shared_preferences_service.dart';
import 'package:mental_health/core/services/quote_service.dart';
import 'package:mental_health/core/services/sqlite_helper.dart';
import 'package:mental_health/features/meditation/data/datasources/meditation_remote_data_source.dart';
import 'package:mental_health/features/meditation/data/repository/meditation_repository_impl.dart';
import 'package:mental_health/features/meditation/domain/repository/meditation_repository.dart';
import 'package:mental_health/features/meditation/domain/usecases/get_daily_quotes.dart';
import 'package:mental_health/features/meditation/domain/usecases/get_mood_message.dart';
import 'package:mental_health/features/meditation/presentation/bloc/daily_quote/daily_quote_bloc.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_bloc.dart';
import 'package:mental_health/features/music/data/datasources/song_remote_data_source.dart';
import 'package:mental_health/features/music/data/repository/song_repository_impl.dart';
import 'package:mental_health/features/music/domain/repository/song_repository.dart';
import 'package:mental_health/features/music/domain/usecases/get_all_songs.dart';
import 'package:mental_health/features/music/presentation/bloc/song_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_bloc.dart';
import 'package:mental_health/features/quotes/injection_container.dart'
    as quotes_di;

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize quotes feature dependencies
  await quotes_di.initQuotes();

  // blocs
  sl.registerFactory(() => DailyQuoteBloc(getDailyQuote: sl()));
  sl.registerFactory(() => MoodMessageBloc(getMoodMessage: sl()));
  sl.registerFactory(() => SongBloc(getAllSongs: sl()));
  sl.registerFactory(() => NavigationBloc());

  // Use cases
  sl.registerLazySingleton(() => GetDailyQuote(repository: sl()));
  sl.registerLazySingleton(() => GetMoodMessage(repository: sl()));
  sl.registerLazySingleton(() => GetAllSongs(repository: sl()));

  sl.registerLazySingleton<MeditationRepository>(
      () => MeditationRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SongRepository>(
      () => SongRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<MeditationRemoteDataSource>(
      () => MeditationRemoteDataSourceImpl(firebaseService: sl()));
  sl.registerLazySingleton<SongRemoteDataSource>(
      () => SongRemoteDataSourceImp(firebaseService: sl()));

  // Core Services
  sl.registerLazySingleton(() => FirebaseService());

  // Register SqliteHelper as singleton
  sl.registerLazySingleton(() => SqliteHelper.instance);

  // Register SharedPreferencesService as singleton
  sl.registerLazySingletonAsync<SharedPreferencesService>(
    () => SharedPreferencesService.getInstance(),
  );

  // Register QuoteService (depends on SharedPreferencesService)
  sl.registerLazySingletonAsync<QuoteService>(
    () async {
      final prefsService = await sl.getAsync<SharedPreferencesService>();
      return QuoteService(prefsService);
    },
  );
}
