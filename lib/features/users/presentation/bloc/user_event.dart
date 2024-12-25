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

class RefreshFetchUsersEvent extends UsersEvent {
  final bool isRefreshing;

  RefreshFetchUsersEvent({this.isRefreshing = false});
}


class ApplyFiltersEvent extends UsersEvent {
  final List<String>? maritalStatus;
  final int? ageMin;
  final int? ageMax;
  final String? ordering;
  final List<String>? countries;
  final List<String>? hijabs;
  final List<String>? le7yas;
  final List<String>? nationalities;
  final List<String>? states;
  final String? gender;

  ApplyFiltersEvent({
    this.maritalStatus,
    this.ageMin,
    this.ageMax,
    this.ordering,
    this.countries,
    this.hijabs,
    this.le7yas,
    this.nationalities,
    this.states,
    this.gender,
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

class SetOnlineEvent extends UsersEvent {}

class SetOfflineEvent extends UsersEvent {}
