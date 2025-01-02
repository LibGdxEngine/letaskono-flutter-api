part of 'notification_bloc.dart';

sealed class NotificationEvent {}

class FetchNotificationsEvent extends NotificationEvent {
  final int page;
  final bool isRefreshing;

  FetchNotificationsEvent({this.page = 1, this.isRefreshing = false});
}

class FetchUnreadNotificationsCountEvent extends NotificationEvent {}
