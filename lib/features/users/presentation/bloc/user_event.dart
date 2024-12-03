// user_event.dart
part of 'user_bloc.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UsersEvent {}

class FetchUserDetailsEvent extends UsersEvent {
  final String userId;

  FetchUserDetailsEvent(this.userId);
}
