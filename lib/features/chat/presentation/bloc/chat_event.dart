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

class SendMessageEvent extends WebSocketEvent {
  final ChatMessageEntity message;
  final int roomId;

  SendMessageEvent(this.message, this.roomId);

  @override
  List<Object> get props => [message, roomId];
}

class ReceiveMessage extends WebSocketEvent {
  final ChatMessageEntity message;

  ReceiveMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ReachMessageLimit extends WebSocketEvent {
  final String message;

  ReachMessageLimit(this.message);

  @override
  List<Object> get props => [message];
}