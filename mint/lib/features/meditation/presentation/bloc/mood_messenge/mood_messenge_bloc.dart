import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/features/meditation/domain/usecases/get_mood_message.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_event.dart';
import 'package:mental_health/features/meditation/presentation/bloc/mood_messenge/mood_messenge_state.dart';

class MoodMessageBloc extends Bloc<MoodMessageEvent, MoodMessageState>{
  final GetMoodMessage getMoodMessage;

  MoodMessageBloc({required this.getMoodMessage}) : super(MoodMessageInitial()) {
    on<FetchMoodMessage>((event, emit) async {
      emit(MoodMessageLoading());
      try{
        final moodMessage = await getMoodMessage(event.mood);
        emit(MoodMessageLoaded(moodMessage: moodMessage));
      } catch(e) {
        emit(MoodMessageError(message: e.toString()));
      }
    });

    on<ResetMoodMessage>((event, emit){
      emit(MoodMessageInitial());
    });
  }
}