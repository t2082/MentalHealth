import 'package:mental_health/features/meditation/data/models/daily_quote_model.dart';
import 'package:mental_health/features/meditation/data/models/mood_messenge_model.dart';
import 'package:mental_health/core/services/firebase_service.dart';

abstract class MeditationRemoteDataSource {
  Future<DailyQuoteModel> getDailyQuote();
  Future<MoodMessengeModel> getMoodMessage(String mood);
}

class MeditationRemoteDataSourceImpl implements MeditationRemoteDataSource {
  final FirebaseService firebaseService;

  MeditationRemoteDataSourceImpl({required this.firebaseService});

  @override
  Future<DailyQuoteModel> getDailyQuote() async {
    return await firebaseService.getDailyQuote();
  }

  @override
  Future<MoodMessengeModel> getMoodMessage(String mood) async {
    return await firebaseService.getMoodMessage(mood);
  }
}
