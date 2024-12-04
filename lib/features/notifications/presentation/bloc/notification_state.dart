part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int currentPage;
  final bool hasMore;

  const NotificationLoaded(this.notifications, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [notifications, currentPage, hasMore];
}

class NotificationLoadingMore extends NotificationState {
  final List<NotificationEntity> notifications;
  final int currentPage;
  final bool hasMore;

  const NotificationLoadingMore(
      this.notifications, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [notifications, currentPage, hasMore];
}

class NotificationFailed extends NotificationState {
  final String error;

  const NotificationFailed(this.error);

  @override
  List<Object> get props => [error];
}

class NotificationLoading extends NotificationState {}
