// home_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>((event, emit) {
      // Load home list (replace with actual logic)
      emit(HomeLoaded(['User 1', 'User 2', 'User 3']));
    });
  }
}
