import 'package:mental_health/features/meditation/domain/entities/daily_quote.dart';
import 'package:mental_health/features/meditation/domain/repository/meditation_repository.dart';

class GetDailyQuotes {
  final MeditationRepository repository;

  GetDailyQuotes({required this.repository});

  Future<DailyQuote> call() async {
    return repository.getDailyQuote();
  }
}
