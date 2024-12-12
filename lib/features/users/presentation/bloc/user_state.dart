part of 'user_bloc.dart';

abstract class UserState {}

class UsersInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserEntity> users;
  final int currentPage;
  final bool hasMore;

  UsersLoaded(this.users, this.currentPage, this.hasMore);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersLoaded &&
          runtimeType == other.runtimeType &&
          users == other.users &&
          currentPage == other.currentPage &&
          hasMore == other.hasMore;

  @override
  int get hashCode => Object.hash(users, currentPage, hasMore);
}

class UserLoadingMore extends UsersLoaded {
  UserLoadingMore(super.users, super.currentPage, super.hasMore);
}

class UserDetailsLoaded extends UserState {
  final UserDetailsEntity user;

  UserDetailsLoaded(this.user);
}

class UsersError extends UserState {
  final String error;

  UsersError(this.error);
}
