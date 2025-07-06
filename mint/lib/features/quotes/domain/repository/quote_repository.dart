import 'package:mental_health/features/quotes/domain/entities/quote.dart';

abstract class QuoteRepository {
  Future<Quote> getQuoteByFeeling(String feeling);
}
