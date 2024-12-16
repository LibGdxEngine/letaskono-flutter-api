part of '../bloc/chat_bloc.dart';


abstract class WebSocketState extends Equatable {
  @override
  List<Object> get props => [];
}

class WebSocketInitial extends WebSocketState {}

class WebSocketConnecting extends WebSocketState {}

class WebSocketConnected extends WebSocketState {}

class WebSocketDisconnected extends WebSocketState {}

class WebSocketError extends WebSocketState {
  final String error;

  WebSocketError(this.error);

  @override
  List<Object> get props => [error];
}

class MessageLimitReached extends WebSocketState {
  final String message;

  MessageLimitReached(this.message);

  @override
  List<Object> get props => [message];
}


class WebSocketMessageReceived extends WebSocketState {
  final ChatMessageEntity message;

  WebSocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}
