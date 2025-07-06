import 'package:get_it/get_it.dart';
import 'package:mental_health/core/services/external_api_service.dart';
import 'package:mental_health/features/quotes/data/datasources/quote_remote_data_source.dart';
import 'package:mental_health/features/quotes/data/repository/quote_repository_impl.dart';
import 'package:mental_health/features/quotes/domain/repository/quote_repository.dart';
import 'package:mental_health/features/quotes/domain/usecases/get_quote_by_feeling.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_bloc.dart';

final sl = GetIt.instance;

Future<void> initQuotes() async {
  // BLoC
  sl.registerFactory(() => QuoteBloc(getQuoteByFeeling: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetQuoteByFeeling(sl()));

  // Repository
  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(externalApiService: sl()),
  );

  // External services
  sl.registerLazySingleton(() => ExternalApiService());
}
