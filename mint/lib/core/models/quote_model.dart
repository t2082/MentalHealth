class QuoteModel {
  final String text;
  final String author;
  final String? translatedText;
  final DateTime fetchedAt;

  QuoteModel({
    required this.text,
    required this.author,
    this.translatedText,
    required this.fetchedAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['q'] ?? json['text'] ?? '',
      author: json['a'] ?? json['author'] ?? 'Unknown',
      translatedText: json['translatedText'],
      fetchedAt: json['fetchedAt'] != null 
          ? DateTime.parse(json['fetchedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'translatedText': translatedText,
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }

  QuoteModel copyWith({
    String? text,
    String? author,
    String? translatedText,
    DateTime? fetchedAt,
  }) {
    return QuoteModel(
      text: text ?? this.text,
      author: author ?? this.author,
      translatedText: translatedText ?? this.translatedText,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  // Get display text (translated if available, otherwise original)
  String get displayText => translatedText ?? text;

  @override
  String toString() {
    return 'QuoteModel(text: $text, author: $author, translatedText: $translatedText, fetchedAt: $fetchedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuoteModel &&
        other.text == text &&
        other.author == author &&
        other.translatedText == translatedText &&
        other.fetchedAt == fetchedAt;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        author.hashCode ^
        translatedText.hashCode ^
        fetchedAt.hashCode;
  }
}
