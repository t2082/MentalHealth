// import 'package:mental_health/features/meditation/data/datasources/meditation_remote_data_source.dart';
// import 'package:mental_health/features/meditation/data/models/mood_messenge_model.dart';
// import 'package:mental_health/features/meditation/domain/entities/daily_quote.dart';
// import 'package:mental_health/features/meditation/domain/repository/meditation_repository.dart';

// class MeditationRepositoryImpl implements MeditationRepository {
//   final MeditationRemoteDataSource remoteDataSource;

//   MeditationRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<List<DailyQuote>> getDailyQuote() async {
//     final dailyQuoteModel = await remoteDataSource.getDailyQuotes();
//     return dailyQuoteModel;
//   }

//   @override
//   Future<List<MoodMessengeModel>> getMoodMessenge({String mood}) async {
//     final moodMessengeModel = await remoteDataSource.getMoodMessenge(mood);
//     return moodMessengeModel;
//   }
// }
