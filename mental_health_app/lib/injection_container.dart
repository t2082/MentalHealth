import 'package:get_it/get_it.dart';
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
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // blocs
  sl.registerFactory(() => DailyQuoteBloc(getDailyQuote: sl()));
  sl.registerFactory(() => MoodMessageBloc(getMoodMessage: sl()));
  sl.registerFactory(() => SongBloc(getAllSongs: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDailyQuote(repository: sl()));
  sl.registerLazySingleton(() => GetMoodMessage(repository: sl()));
  sl.registerLazySingleton(() => GetAllSongs(repository: sl()));

  sl.registerLazySingleton<MeditationRepository>(
      () => MeditationRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SongRepository>(
      () => SongRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<MeditationRemoteDataSource>(
      () => MeditationRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<SongRemoteDataSource>(
      () => SongRemoteDataSourceImp(client: sl()));

  sl.registerLazySingleton(() => http.Client());
}
