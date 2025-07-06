import 'package:equatable/equatable.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class GetQuoteByFeelingEvent extends QuoteEvent {
  final String feeling;

  const GetQuoteByFeelingEvent(this.feeling);

  @override
  List<Object> get props => [feeling];
}
