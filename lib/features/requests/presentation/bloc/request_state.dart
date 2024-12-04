part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestsInitial extends RequestState {}

class RequestsLoading extends RequestState {}

class RequestsLoaded extends RequestState {
  final List<AcceptanceRequestEntity> requests;

  RequestsLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}


class RequestsError extends RequestState {
  final String error;

  RequestsError(this.error);

  @override
  List<Object?> get props => [error];
}
