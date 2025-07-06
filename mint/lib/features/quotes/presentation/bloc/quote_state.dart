import 'package:equatable/equatable.dart';
import 'package:mental_health/features/quotes/domain/entities/quote.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final Quote quote;

  const QuoteLoaded(this.quote);

  @override
  List<Object> get props => [quote];
}

class QuoteError extends QuoteState {
  final String message;

  const QuoteError(this.message);

  @override
  List<Object> get props => [message];
}
