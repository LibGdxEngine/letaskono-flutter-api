// user_event.dart
part of 'user_bloc.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsersEvent extends UsersEvent {
  final int page;
  final bool isRefreshing;

  FetchUsersEvent({this.page = 1, this.isRefreshing = false});
}

class FetchFavouritesEvent extends UsersEvent {
  final int page;
  final bool isRefreshing;

  FetchFavouritesEvent({this.page = 1, this.isRefreshing = false});
}

class FetchUserDetailsEvent extends UsersEvent {
  final String userId;

  FetchUserDetailsEvent(this.userId);
}
