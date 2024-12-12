part of 'action_btn_bloc.dart';

abstract class ActionBtnState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ActionBtnInitial extends ActionBtnState {}

class RequestSentLoading extends ActionBtnState {}

class RequestSentSuccess extends ActionBtnState {
  final String result;

  RequestSentSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RequestAcceptedSuccess extends ActionBtnState {
  final String result;

  RequestAcceptedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RequestSentFailed extends ActionBtnState {
  final String reason;

  RequestSentFailed(this.reason);

  @override
  List<Object?> get props => [reason];
}

class AddToFavouritesSuccess extends ActionBtnState {
  final String result;

  AddToFavouritesSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RemoveFromFavouritesSuccess extends ActionBtnState {
  final String result;

  RemoveFromFavouritesSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class AddToBlockListSuccess extends ActionBtnState {
  final String result;

  AddToBlockListSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class RemoveFromBlockListSuccess extends ActionBtnState {
  final String result;

  RemoveFromBlockListSuccess(this.result);

  @override
  List<Object?> get props => [result];
}
