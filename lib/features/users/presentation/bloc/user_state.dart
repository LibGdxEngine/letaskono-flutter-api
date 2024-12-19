part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class UsersInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UsersLoaded extends UserState {
  final List<UserEntity> users;
  final int currentPage;
  final bool hasMore;

  UsersLoaded(this.users, this.currentPage, this.hasMore);

  @override
  List<Object?> get props => [users];
}

class UserLoadingMore extends UsersLoaded {
  UserLoadingMore(super.users, super.currentPage, super.hasMore);
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
