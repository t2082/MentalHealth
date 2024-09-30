import 'dart:convert';

import 'package:mental_health/features/meditation/data/models/daily_quote_model.dart';
import 'package:mental_health/features/meditation/data/models/mood_messenge_model.dart';
import 'package:http/http.dart' as http;

abstract class MeditationRemoteDataSource {
  Future<DailyQuoteModel> getDailyQuotes();
  Future<MoodMessengeModel> getMoodMessenge(String mood);
}

class MeditationRemoteDataSourceImp implements MeditationRemoteDataSource {
  final http.Client client;

  MeditationRemoteDataSourceImp({required this.client});

  @override
  Future<DailyQuoteModel> getDailyQuotes() async{
    final response = await client.get(Uri.parse('http://10.0.2.2:6000/meditation/dailyQuote'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // print('RepBody: ${jsonResponse}');
      return DailyQuoteModel.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load model: meditaion_remote_data_source.dart');
    }
  }

  @override
  Future<MoodMessengeModel> getMoodMessenge(String mood) async{
    final response = await client.get(Uri.parse('http://10.0.2.2:6000/meditation/myMood/$mood'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // print('RepBody: ${jsonResponse}');
      return MoodMessengeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Fail to load model: meditaion_remote_data_source.dart');
    }
  }
}
