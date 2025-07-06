import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:mental_health/core/models/quote_model.dart';
import 'package:mental_health/core/services/shared_preferences_service.dart';

class QuoteService {
  static const String _zenQuotesApiUrl = 'https://zenquotes.io/api/random';
  static const String _defaultQuote =
      'Mỗi phút bạn dành cho chính mình hôm nay là một hạt giống hạnh phúc cho ngày mai.';
  static const String _defaultAuthor = 'Mint';

  final GoogleTranslator _translator = GoogleTranslator();
  final SharedPreferencesService _prefsService;

  QuoteService(this._prefsService);

  /// Get quote for display - returns cached quote or default quote
  Future<String> getDisplayQuote() async {
    try {
      // Check if we have a cached quote
      final cachedQuote = await _prefsService.getDailyQuote();
      final cachedAuthor = await _prefsService.getQuoteAuthor();

      if (cachedQuote != null && cachedQuote.isNotEmpty) {
        if (cachedAuthor != null && cachedAuthor.isNotEmpty) {
          return '$cachedQuote\n\n- $cachedAuthor -';
        }
        return cachedQuote;
      }

      // Return default quote if no cached quote
      return '$_defaultQuote\n\n- $_defaultAuthor -';
    } catch (e) {
      print('Error getting display quote: $e');
      return '$_defaultQuote\n\n- $_defaultAuthor -';
    }
  }

  /// Fetch new quote from API and update cache
  Future<void> fetchAndCacheNewQuote() async {
    try {
      // Fetch quote from API
      final quote = await _fetchQuoteFromApi();

      if (quote != null) {
        // Translate to Vietnamese
        final translatedQuote = await _translateQuote(quote);

        // Cache the translated quote and author
        await _prefsService.setDailyQuote(translatedQuote.displayText);
        await _prefsService.setQuoteAuthor(translatedQuote.author);
        await _prefsService.setQuoteDate(DateTime.now().toIso8601String());

        print(
            'New quote cached: ${translatedQuote.displayText} - ${translatedQuote.author}');
      }
    } catch (e) {
      print('Error fetching and caching new quote: $e');
      // If error occurs and no cached quote exists, cache the default quote
      final cachedQuote = await _prefsService.getDailyQuote();
      if (cachedQuote == null || cachedQuote.isEmpty) {
        await _prefsService.setDailyQuote(_defaultQuote);
        await _prefsService.setQuoteAuthor(_defaultAuthor);
      }
    }
  }

  /// Check if we should fetch a new quote (daily basis)
  Future<bool> shouldFetchNewQuote() async {
    try {
      final lastFetchDate = await _prefsService.getQuoteDate();
      if (lastFetchDate == null) return true;

      final lastFetch = DateTime.parse(lastFetchDate);
      final now = DateTime.now();

      // Check if it's a new day
      return lastFetch.day != now.day ||
          lastFetch.month != now.month ||
          lastFetch.year != now.year;
    } catch (e) {
      print('Error checking if should fetch new quote: $e');
      return true;
    }
  }

  /// Initialize quote service - call this when app starts
  Future<void> initialize() async {
    try {
      final isFirstLaunch = await _prefsService.isFirstLaunch();

      if (isFirstLaunch) {
        // First launch - set default quote and mark as not first launch
        await _prefsService.setDailyQuote(_defaultQuote);
        await _prefsService.setQuoteAuthor(_defaultAuthor);
        await _prefsService.setFirstLaunchCompleted();

        // Fetch new quote in background for next time
        fetchAndCacheNewQuote();
      } else {
        // Not first launch - check if we need to fetch new quote
        if (await shouldFetchNewQuote()) {
          fetchAndCacheNewQuote();
        }
      }
    } catch (e) {
      print('Error initializing quote service: $e');
    }
  }

  /// Fetch quote from ZenQuotes API
  Future<QuoteModel?> _fetchQuoteFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(_zenQuotesApiUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return QuoteModel.fromJson(data[0]);
        }
      }

      print('API response error: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Error fetching quote from API: $e');
      return null;
    }
  }

  /// Translate quote to Vietnamese
  Future<QuoteModel> _translateQuote(QuoteModel quote) async {
    try {
      // Translate the quote text
      final translatedText = await _translator.translate(
        quote.text,
        from: 'en',
        to: 'vi',
      );

      // Translate author name if it's not a common name
      String translatedAuthor = quote.author;
      if (quote.author.toLowerCase() != 'unknown' &&
          quote.author.toLowerCase() != 'anonymous') {
        try {
          final authorTranslation = await _translator.translate(
            quote.author,
            from: 'en',
            to: 'vi',
          );
          translatedAuthor = authorTranslation.text;
        } catch (e) {
          // Keep original author name if translation fails
          print('Error translating author: $e');
        }
      }

      return quote.copyWith(
        translatedText: translatedText.text,
        author: translatedAuthor,
      );
    } catch (e) {
      print('Error translating quote: $e');
      // Return original quote if translation fails
      return quote;
    }
  }

  /// Get a random motivational quote (fallback method)
  String getRandomMotivationalQuote() {
    final quotes = [
      'Mỗi phút bạn dành cho chính mình hôm nay là một hạt giống hạnh phúc cho ngày mai.',
      'Hạnh phúc không phải là điều gì đó có sẵn. Nó đến từ hành động của chính bạn.',
      'Cuộc sống không phải là chờ đợi cơn bão qua đi, mà là học cách nhảy múa trong mưa.',
      'Bạn mạnh mẽ hơn những gì bạn nghĩ và dũng cảm hơn những gì bạn cảm thấy.',
      'Mỗi ngày mới là một cơ hội để trở thành phiên bản tốt nhất của chính mình.',
    ];

    final index = DateTime.now().millisecond % quotes.length;
    return quotes[index];
  }
}
