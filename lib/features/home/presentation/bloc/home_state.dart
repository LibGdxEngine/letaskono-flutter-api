// home_state.dart
part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

// Initial state when nothing has been loaded yet
class HomeInitial extends HomeState {}

// State when the home list is loaded successfully
class HomeLoaded extends HomeState {
  final List<String> users; // This can be a list of users or any other data structure

  const HomeLoaded(this.users);

  @override
  List<Object> get props => [users];
}

// State for error during loading
class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
