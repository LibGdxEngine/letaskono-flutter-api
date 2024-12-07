// user_event.dart
part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRequestsEvent extends RequestEvent {
  final int page;
  final bool isRefreshing;

  FetchRequestsEvent({this.page = 1, this.isRefreshing = false});
}

class FetchFavouritesEvent extends RequestEvent {}

class FetchUserDetailsEvent extends RequestEvent {
  final String userId;

  FetchUserDetailsEvent(this.userId);
}
