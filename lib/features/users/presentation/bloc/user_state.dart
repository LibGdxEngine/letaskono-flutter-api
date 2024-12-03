part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;

  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserDetailsLoaded extends UserState {
  final UserDetailsEntity user;

  UserDetailsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UsersError extends UserState {
  final String error;

  UsersError(this.error);

  @override
  List<Object?> get props => [error];
}
