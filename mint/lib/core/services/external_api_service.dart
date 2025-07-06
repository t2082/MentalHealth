import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Service để quản lý tất cả các external APIs
/// Mục đích: Dễ dàng thay đổi API khi có lỗi
class ExternalApiService {
  static const Duration _timeout = Duration(seconds: 10);

  // HTTP client với cấu hình SSL linh hoạt
  late final http.Client _httpClient;

  ExternalApiService() {
    _httpClient = _createHttpClient();
  }

  /// Tạo HTTP client với cấu hình SSL
  http.Client _createHttpClient() {
    final client = HttpClient();

    // Cấu hình SSL để xử lý certificate issues
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      log('⚠️ SSL Certificate warning for $host:$port');
      log('📋 Certificate subject: ${cert.subject}');
      log('📅 Certificate valid from: ${cert.startValidity}');
      log('📅 Certificate valid to: ${cert.endValidity}');

      // Cho phép certificate từ các domain tin cậy
      final trustedHosts = [
        'api.quotable.io',
        'zenquotes.io',
        'www.affirmations.dev'
      ];

      if (trustedHosts.contains(host)) {
        log('✅ Allowing certificate for trusted host: $host');
        return true;
      }

      log('❌ Rejecting certificate for untrusted host: $host');
      return false;
    };

    return IOClient(client);
  }

  /// Dispose HTTP client
  void dispose() {
    _httpClient.close();
  }

  /// Test kết nối đến Quotable.io
  Future<bool> testQuotableConnection() async {
    log('🔍 Testing connection to Quotable.io...');
    try {
      final response = await _httpClient.get(
        Uri.parse('https://api.quotable.io/random'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MintMentalHealthApp/1.0',
        },
      ).timeout(_timeout);

      log('✅ Quotable.io connection test successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      log('❌ Quotable.io connection test failed: $e');
      return false;
    }
  }

  // Quotable.io APIs - Primary APIs
  static const String _quotableBaseUrl = 'https://api.quotable.io';
  static const String _quotableGoalsUrl =
      '$_quotableBaseUrl/random?tags=success%7Cmotivational%7Cgoals%7Cchallenge';
  static const String _quotableSportsUrl =
      '$_quotableBaseUrl/random?tags=sports%7Cfitness%7Cperseverance%7Cdiscipline';
  static const String _quotableLoveUrl =
      '$_quotableBaseUrl/random?tags=love%7Cromance%7Cfriendship%7Crelationships';
  static const String _quotableConfidenceUrl =
      '$_quotableBaseUrl/random?tags=confidence%7Cinspirational%7Cmotivational';

  // Fallback APIs
  static const String _zenQuotesUrl = 'https://zenquotes.io/api/random';
  static const String _affirmationsUrl = 'https://www.affirmations.dev/';

  /// Lấy quote cho "Mục tiêu"
  Future<Map<String, dynamic>> getGoalsQuote() async {
    log('🎯 Fetching quote for "Mục tiêu" (Goals)');
    try {
      log('📡 Trying primary API: Quotable.io (Goals)');
      log('🔗 URL: $_quotableGoalsUrl');
      final response = await _makeRequest(_quotableGoalsUrl);
      log('✅ Successfully fetched from Quotable.io (Goals)');
      return _parseQuotableResponse(response);
    } catch (e) {
      log('❌ Primary API failed: $e');
      // Fallback to ZenQuotes
      try {
        log('📡 Trying fallback API: ZenQuotes.io');
        log('🔗 URL: $_zenQuotesUrl');
        final response = await _makeRequest(_zenQuotesUrl);
        log('✅ Successfully fetched from ZenQuotes.io (fallback)');
        return _parseZenQuotesResponse(response);
      } catch (fallbackError) {
        log('❌ Fallback API also failed: $fallbackError');
        throw Exception(
            'Failed to fetch goals quote: $e, Fallback error: $fallbackError');
      }
    }
  }

  /// Lấy quote cho "Vận động"
  Future<Map<String, dynamic>> getSportsQuote() async {
    log('🏃‍♂️ Fetching quote for "Vận động" (Sports)');
    try {
      log('📡 Trying primary API: Quotable.io (Sports)');
      log('🔗 URL: $_quotableSportsUrl');
      final response = await _makeRequest(_quotableSportsUrl);
      log('✅ Successfully fetched from Quotable.io (Sports)');
      log('📄 Response: ${response.body}');
      return _parseQuotableResponse(response);
    } catch (e) {
      log('❌ Primary API failed: $e');
      // Fallback to ZenQuotes
      try {
        log('📡 Trying fallback API: ZenQuotes.io');
        log('🔗 URL: $_zenQuotesUrl');
        final response = await _makeRequest(_zenQuotesUrl);
        log('✅ Successfully fetched from ZenQuotes.io (fallback)');
        return _parseZenQuotesResponse(response);
      } catch (fallbackError) {
        log('❌ Fallback API also failed: $fallbackError');
        throw Exception(
            'Failed to fetch sports quote: $e, Fallback error: $fallbackError');
      }
    }
  }

  /// Lấy quote cho "Gắn kết"
  Future<Map<String, dynamic>> getLoveQuote() async {
    log('💕 Fetching quote for "Gắn kết" (Love/Connection)');
    try {
      log('📡 Trying primary API: Quotable.io (Love)');
      log('🔗 URL: $_quotableLoveUrl');
      final response = await _makeRequest(_quotableLoveUrl);
      log('✅ Successfully fetched from Quotable.io (Love)');
      return _parseQuotableResponse(response);
    } catch (e) {
      log('❌ Primary API failed: $e');
      // Fallback to ZenQuotes
      try {
        log('📡 Trying fallback API: ZenQuotes.io');
        log('🔗 URL: $_zenQuotesUrl');
        final response = await _makeRequest(_zenQuotesUrl);
        log('✅ Successfully fetched from ZenQuotes.io (fallback)');
        return _parseZenQuotesResponse(response);
      } catch (fallbackError) {
        log('❌ Fallback API also failed: $fallbackError');
        throw Exception(
            'Failed to fetch love quote: $e, Fallback error: $fallbackError');
      }
    }
  }

  /// Lấy quote cho "Tự tin"
  Future<Map<String, dynamic>> getConfidenceQuote() async {
    log('💪 Fetching quote for "Tự tin" (Confidence)');
    try {
      log('📡 Trying primary API: Quotable.io (Confidence)');
      log('🔗 URL: $_quotableConfidenceUrl');
      final response = await _makeRequest(_quotableConfidenceUrl);
      log('✅ Successfully fetched from Quotable.io (Confidence)');
      return _parseQuotableResponse(response);
    } catch (e) {
      log('❌ Primary API failed: $e');
      try {
        log('📡 Trying first fallback API: Affirmations.dev');
        log('🔗 URL: $_affirmationsUrl');
        final response = await _makeRequest(_affirmationsUrl);
        log('✅ Successfully fetched from Affirmations.dev (fallback)');
        return _parseAffirmationsResponse(response);
      } catch (fallbackError) {
        log('❌ First fallback API failed: $fallbackError');
        // Second fallback to ZenQuotes
        try {
          log('📡 Trying second fallback API: ZenQuotes.io');
          log('🔗 URL: $_zenQuotesUrl');
          final response = await _makeRequest(_zenQuotesUrl);
          log('✅ Successfully fetched from ZenQuotes.io (second fallback)');
          return _parseZenQuotesResponse(response);
        } catch (secondFallbackError) {
          log('❌ Second fallback API also failed: $secondFallbackError');
          throw Exception(
              'Failed to fetch confidence quote: $e, Fallback errors: $fallbackError, $secondFallbackError');
        }
      }
    }
  }

  /// Lấy quote theo feeling type
  Future<Map<String, dynamic>> getQuoteByFeeling(String feeling) async {
    log('🎭 Getting quote by feeling: "$feeling"');
    switch (feeling.toLowerCase()) {
      case 'mục tiêu':
        return await getGoalsQuote();
      case 'vận động':
        return await getSportsQuote();
      case 'gắn kết':
        return await getLoveQuote();
      case 'tự tin':
        return await getConfidenceQuote();
      default:
        log('❓ Unknown feeling type: $feeling');
        throw Exception('Unknown feeling type: $feeling');
    }
  }

  /// Thực hiện HTTP request với timeout
  Future<http.Response> _makeRequest(String url) async {
    log('🌐 Making HTTP request to: $url');
    log('⏰ Current time: ${DateTime.now()}');

    try {
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'MintMentalHealthApp/1.0',
        },
      ).timeout(_timeout);

      log('📊 Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
            'HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }

      return response;
    } catch (e) {
      log('❌ HTTP request failed: $e');
      rethrow;
    }
  }

  /// Parse response từ Quotable.io
  Map<String, dynamic> _parseQuotableResponse(http.Response response) {
    log('📝 Parsing response from Quotable.io');
    final data = json.decode(response.body);
    final result = {
      'content': data['content'] ?? '',
      'author': data['author'] ?? 'Unknown',
      'source': 'quotable.io',
    };
    log('📋 Parsed quote: "${result['content']}" - ${result['author']}');
    return result;
  }

  /// Parse response từ ZenQuotes.io
  Map<String, dynamic> _parseZenQuotesResponse(http.Response response) {
    log('📝 Parsing response from ZenQuotes.io');
    final data = json.decode(response.body);
    if (data is List && data.isNotEmpty) {
      final quote = data[0];
      final result = {
        'content': quote['q'] ?? '',
        'author': quote['a'] ?? 'Unknown',
        'source': 'zenquotes.io',
      };
      log('📋 Parsed quote: "${result['content']}" - ${result['author']}');
      return result;
    }
    log('❌ Invalid ZenQuotes response format');
    throw Exception('Invalid ZenQuotes response format');
  }

  /// Parse response từ Affirmations.dev
  Map<String, dynamic> _parseAffirmationsResponse(http.Response response) {
    log('📝 Parsing response from Affirmations.dev');
    final data = json.decode(response.body);
    final result = {
      'content': data['affirmation'] ?? '',
      'author': 'Affirmations.dev',
      'source': 'affirmations.dev',
    };
    log('📋 Parsed quote: "${result['content']}" - ${result['author']}');
    return result;
  }
}
