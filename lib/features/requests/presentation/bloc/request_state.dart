part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestsInitial extends RequestState {}

class RequestsLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<AcceptanceRequestEntity> requests;

  final int currentPage;
  final bool hasMore;

  RequestsLoaded(this.requests, this.currentPage, this.hasMore);

  @override
  List<Object?> get props => [requests];
}

class RequestsLoadingMore extends RequestState {
  final List<AcceptanceRequestEntity> requests;
  final int currentPage;
  final bool hasMore;

  RequestsLoadingMore(this.requests, this.currentPage, this.hasMore);

  @override
  List<Object> get props => [requests, currentPage, hasMore];
}

class RequestsError extends RequestState {
  final String error;

  RequestsError(this.error);

  @override
  List<Object?> get props => [error];
}
