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

class ApplyFiltersEvent extends UsersEvent {
  final String maritalStatus;
  final int ageMin;
  final int ageMax;
  final String ordering;
  final List<String> countries;
  final List<String> states;
  final String gender;

  ApplyFiltersEvent({
    required this.maritalStatus,
    required this.ageMin,
    required this.ageMax,
    required this.ordering,
    required this.countries,
    required this.states,
    required this.gender,
  });
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
