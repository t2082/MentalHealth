import 'package:mental_health/features/quotes/domain/entities/quote.dart';
import 'package:mental_health/features/quotes/domain/repository/quote_repository.dart';

class GetQuoteByFeeling {
  final QuoteRepository repository;

  GetQuoteByFeeling(this.repository);

  Future<Quote> call(String feeling) async {
    return await repository.getQuoteByFeeling(feeling);
  }
}
