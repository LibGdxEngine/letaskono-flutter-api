// user_event.dart
part of 'request_bloc.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRequestsEvent extends UsersEvent {}

class FetchFavouritesEvent extends UsersEvent {}

class FetchUserDetailsEvent extends UsersEvent {
  final String userId;

  FetchUserDetailsEvent(this.userId);
}
