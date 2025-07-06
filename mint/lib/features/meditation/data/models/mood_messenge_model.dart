import 'package:mental_health/features/meditation/domain/entities/mood_message.dart';

class MoodMessengeModel extends MoodMessage {
  MoodMessengeModel({required super.text});

  factory MoodMessengeModel.fromJson(Map<String, dynamic> json) {
    return MoodMessengeModel(text: json['text']);
  }
}
