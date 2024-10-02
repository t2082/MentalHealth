import 'dart:convert';

import 'package:mental_health/features/meditation/data/models/daily_quote_model.dart';
import 'package:http/http.dart' as http;
import 'package:mental_health/features/meditation/data/models/mood_messenge_model.dart';

abstract class MeditationRemoteDataSource {
  Future<DailyQuoteModel> getDailyQuote();
  Future<MoodMessengeModel> getMoodMessage(String mood);
}

class MeditationRemoteDataSourceImpl implements MeditationRemoteDataSource {
  final http.Client client;

  MeditationRemoteDataSourceImpl({required this.client});

  @override
  Future<DailyQuoteModel> getDailyQuote() async {
    final response = await client
        .get(Uri.parse('http://10.0.2.2:6000/meditation/dailyQuote'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return DailyQuoteModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load daily quote');
    }
  }

  @override
  Future<MoodMessengeModel> getMoodMessage(String mood) async {
    final response = await client
        .get(Uri.parse('http://10.0.2.2:6000/meditation/myMood/happy'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MoodMessengeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load mood quote');
    }
  }
}
