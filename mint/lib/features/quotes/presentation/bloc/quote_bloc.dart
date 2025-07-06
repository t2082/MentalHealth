import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/features/quotes/domain/entities/quote.dart';
import 'package:mental_health/features/quotes/domain/usecases/get_quote_by_feeling.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_event.dart';
import 'package:mental_health/features/quotes/presentation/bloc/quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuoteByFeeling getQuoteByFeeling;

  // Cache để lưu quotes theo từng feeling
  static final Map<String, Quote> _quotesCache = {};

  QuoteBloc({required this.getQuoteByFeeling}) : super(QuoteInitial()) {
    on<GetQuoteByFeelingEvent>(_onGetQuoteByFeeling);
  }

  Future<void> _onGetQuoteByFeeling(
    GetQuoteByFeelingEvent event,
    Emitter<QuoteState> emit,
  ) async {
    // Kiểm tra cache trước
    if (_quotesCache.containsKey(event.feeling)) {
      emit(QuoteLoaded(_quotesCache[event.feeling]!));
      return;
    }

    emit(QuoteLoading());
    try {
      final quote = await getQuoteByFeeling(event.feeling);
      // Lưu vào cache
      _quotesCache[event.feeling] = quote;
      emit(QuoteLoaded(quote));
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }

  // Method để clear cache nếu cần
  static void clearCache() {
    _quotesCache.clear();
  }

  // Method để clear cache cho một feeling cụ thể
  static void clearCacheForFeeling(String feeling) {
    _quotesCache.remove(feeling);
  }
}
