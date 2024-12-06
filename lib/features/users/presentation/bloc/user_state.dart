part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;
  final int currentPage;
  final bool hasMore;

  UsersLoaded(this.users, this.currentPage, this.hasMore);

  @override
  List<Object?> get props => [users, currentPage, hasMore];
}

class UserLoadingMore extends UserState {
  final List<UserEntity> users;
  final int currentPage;
  final bool hasMore;

  UserLoadingMore(this.users, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [users, currentPage, hasMore];
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
