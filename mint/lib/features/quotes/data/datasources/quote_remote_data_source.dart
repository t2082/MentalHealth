import 'dart:developer';
import 'package:mental_health/core/services/external_api_service.dart';
import 'package:mental_health/features/quotes/data/models/quote_model.dart';
import 'package:translator/translator.dart';

abstract class QuoteRemoteDataSource {
  Future<QuoteModel> getQuoteByFeeling(String feeling);
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final ExternalApiService externalApiService;
  final GoogleTranslator _translator = GoogleTranslator();

  QuoteRemoteDataSourceImpl({required this.externalApiService});

  @override
  Future<QuoteModel> getQuoteByFeeling(String feeling) async {
    log('🔄 QuoteRemoteDataSource: Starting to fetch quote for feeling "$feeling"');
    try {
      final quoteData = await externalApiService.getQuoteByFeeling(feeling);
      log('📦 QuoteRemoteDataSource: Received quote data from API');
      final quote = QuoteModel.fromJson(quoteData, feeling);
      log('🏗️ QuoteRemoteDataSource: Created QuoteModel from API data');

      // Translate to Vietnamese
      log('🌐 QuoteRemoteDataSource: Starting translation to Vietnamese');
      final translatedQuote = await _translateQuote(quote);
      log('✅ QuoteRemoteDataSource: Successfully completed quote fetch and translation');
      return translatedQuote;
    } catch (e) {
      log('❌ QuoteRemoteDataSource: Failed to fetch quote for feeling "$feeling": $e');
      throw Exception('Failed to fetch quote for feeling "$feeling": $e');
    }
  }

  /// Translate quote to Vietnamese
  Future<QuoteModel> _translateQuote(QuoteModel quote) async {
    log('🔤 Starting translation for quote: "${quote.content.substring(0, quote.content.length > 50 ? 50 : quote.content.length)}..."');
    try {
      // Translate the quote content
      final translatedContent = await _translator.translate(
        quote.content,
        from: 'en',
        to: 'vi',
      );
      log('✅ Translation completed successfully');
      log('🔤 Original: "${quote.content}"');
      log('🔤 Translated: "${translatedContent.text}"');

      return quote.copyWith(
        translatedContent: translatedContent.text,
      );
    } catch (e) {
      log('❌ Error translating quote: $e');
      log('⚠️ Returning original quote without translation');
      return quote;
    }
  }
}
