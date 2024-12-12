part of '../bloc/chat_bloc.dart';

abstract class WebSocketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectWebSocket extends WebSocketEvent {
  final int roomId;

  ConnectWebSocket(this.roomId);
}

class DisconnectWebSocket extends WebSocketEvent {}

class SendMessage extends WebSocketEvent {
  final String message;

  SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReceiveMessage extends WebSocketEvent {
  final ChatMessageEntity message;

  ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}
