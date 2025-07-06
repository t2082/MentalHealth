import 'package:mental_health/features/quotes/data/datasources/quote_remote_data_source.dart';
import 'package:mental_health/features/quotes/domain/entities/quote.dart';
import 'package:mental_health/features/quotes/domain/repository/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource remoteDataSource;

  QuoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Quote> getQuoteByFeeling(String feeling) async {
    return await remoteDataSource.getQuoteByFeeling(feeling);
  }
}
