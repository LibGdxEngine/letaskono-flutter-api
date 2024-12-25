part of '../bloc/chat_bloc.dart';

abstract class WebSocketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchChatRoomsEvent extends WebSocketEvent {
  final int page;
  final bool isRefreshing;

  FetchChatRoomsEvent({this.page = 1, this.isRefreshing = false});
}

class RefreshFetchChatRoomsEvent extends WebSocketEvent {
  final bool isRefreshing;

  RefreshFetchChatRoomsEvent({this.isRefreshing = false});
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

class ChatStateUpdated extends WebSocketEvent {
  final String state;
  final int roomId;

  ChatStateUpdated(this.state, this.roomId);

  @override
  List<Object> get props => [state, roomId];
}

class EnterKhetbaPage extends WebSocketEvent {
  final int roomId;

  EnterKhetbaPage(this.roomId);

  @override
  List<Object> get props => [roomId];
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
