import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health/core/models/quote_model.dart';

void main() {
  group('QuoteModel Tests', () {
    test('should create QuoteModel from JSON', () {
      final json = {
        'q': 'Test quote',
        'a': 'Test Author',
        'translatedText': 'Câu nói test',
        'fetchedAt': '2023-01-01T00:00:00.000Z',
      };
      
      final quote = QuoteModel.fromJson(json);
      
      expect(quote.text, 'Test quote');
      expect(quote.author, 'Test Author');
      expect(quote.translatedText, 'Câu nói test');
      expect(quote.displayText, 'Câu nói test');
    });

    test('should use original text when no translation available', () {
      final json = {
        'q': 'Test quote',
        'a': 'Test Author',
      };
      
      final quote = QuoteModel.fromJson(json);
      
      expect(quote.displayText, 'Test quote');
    });

    test('should convert QuoteModel to JSON', () {
      final quote = QuoteModel(
        text: 'Test quote',
        author: 'Test Author',
        translatedText: 'Câu nói test',
        fetchedAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
      );
      
      final json = quote.toJson();
      
      expect(json['text'], 'Test quote');
      expect(json['author'], 'Test Author');
      expect(json['translatedText'], 'Câu nói test');
      expect(json['fetchedAt'], '2023-01-01T00:00:00.000Z');
    });

    test('should create copy with updated values', () {
      final original = QuoteModel(
        text: 'Original text',
        author: 'Original Author',
        fetchedAt: DateTime.now(),
      );
      
      final copy = original.copyWith(
        translatedText: 'Translated text',
      );
      
      expect(copy.text, original.text);
      expect(copy.author, original.author);
      expect(copy.translatedText, 'Translated text');
      expect(copy.fetchedAt, original.fetchedAt);
    });

    test('should handle equality correctly', () {
      final date = DateTime.now();
      final quote1 = QuoteModel(
        text: 'Same text',
        author: 'Same Author',
        fetchedAt: date,
      );
      
      final quote2 = QuoteModel(
        text: 'Same text',
        author: 'Same Author',
        fetchedAt: date,
      );
      
      expect(quote1, equals(quote2));
      expect(quote1.hashCode, equals(quote2.hashCode));
    });
  });

  group('Date Logic Tests', () {
    test('should handle date comparison logic correctly', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final sameDay = DateTime(now.year, now.month, now.day, 10, 30);
      
      // Test same day logic
      expect(now.day == sameDay.day && 
             now.month == sameDay.month && 
             now.year == sameDay.year, true);
      
      // Test different day logic
      expect(now.day != yesterday.day || 
             now.month != yesterday.month || 
             now.year != yesterday.year, true);
    });
  });
}
