import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String content;
  final String author;
  final String source;
  final String feeling;
  final String? translatedContent;

  const Quote({
    required this.content,
    required this.author,
    required this.source,
    required this.feeling,
    this.translatedContent,
  });

  /// Get display content (translated if available, otherwise original)
  String get displayContent => translatedContent ?? content;

  @override
  List<Object?> get props =>
      [content, author, source, feeling, translatedContent];

  @override
  String toString() {
    return 'Quote(content: $content, author: $author, source: $source, feeling: $feeling, translatedContent: $translatedContent)';
  }
}
