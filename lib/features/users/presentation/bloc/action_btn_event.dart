// user_event.dart
part of 'action_btn_bloc.dart';

abstract class ActionBtnEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendRequestEvent extends ActionBtnEvent {
  final String userCode;

  SendRequestEvent(this.userCode);
}

class AddToFavouritesEvent extends ActionBtnEvent {
  final String userCode;

  AddToFavouritesEvent(this.userCode);
}

class RemoveFromFavouritesEvent extends ActionBtnEvent {
  final String userCode;

  RemoveFromFavouritesEvent(this.userCode);
}

class AddToBlackListEvent extends ActionBtnEvent {
  final String userCode;

  AddToBlackListEvent(this.userCode);
}

class RemoveFromBlackListEvent extends ActionBtnEvent {
  final String userCode;

  RemoveFromBlackListEvent(this.userCode);
}