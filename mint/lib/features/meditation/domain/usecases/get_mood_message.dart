// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mental_health/features/meditation/domain/entities/mood_message.dart';
import 'package:mental_health/features/meditation/domain/repository/meditation_repository.dart';

class GetMoodMessage {
  final MeditationRepository repository;

  GetMoodMessage({required this.repository});

  Future<MoodMessage> call(String mood) async {
    return await repository.getMoodMessage(mood);
  }
}
