import 'package:mental_health/features/quotes/domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.content,
    required super.author,
    required super.source,
    required super.feeling,
    super.translatedContent,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json, String feeling) {
    return QuoteModel(
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
      source: json['source'] ?? 'Unknown',
      feeling: feeling,
      translatedContent: json['translatedContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'author': author,
      'source': source,
      'feeling': feeling,
      'translatedContent': translatedContent,
    };
  }

  factory QuoteModel.fromEntity(Quote quote) {
    return QuoteModel(
      content: quote.content,
      author: quote.author,
      source: quote.source,
      feeling: quote.feeling,
      translatedContent: quote.translatedContent,
    );
  }

  QuoteModel copyWith({
    String? content,
    String? author,
    String? source,
    String? feeling,
    String? translatedContent,
  }) {
    return QuoteModel(
      content: content ?? this.content,
      author: author ?? this.author,
      source: source ?? this.source,
      feeling: feeling ?? this.feeling,
      translatedContent: translatedContent ?? this.translatedContent,
    );
  }
}
