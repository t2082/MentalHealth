import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_event.dart';
import 'package:mental_health/presentation/bottomNavBar/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationChange(index: 0)) {
    on<NavigationTo>((event, emit) {
      // Nhận Event từ người dùng (event) emit để xử lý trạng thái mới
      emit(NavigationChange(index: event.index));
    });
  }
}
