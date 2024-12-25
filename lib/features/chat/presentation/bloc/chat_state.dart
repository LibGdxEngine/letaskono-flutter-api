part of '../bloc/chat_bloc.dart';

abstract class WebSocketState extends Equatable {}

class ChatRoomsInitial extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class ChatRoomsLoading extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class ChatRoomStateUpdated extends WebSocketState {
  final String roomId;
  final String maleState;
  final String femaleState;

  ChatRoomStateUpdated(this.roomId, this.maleState, this.femaleState);

  @override
  List<Object?> get props => [roomId, maleState, femaleState];
}

class KhetbaStageEntered extends WebSocketState {
  ChatRoom room;

  KhetbaStageEntered(this.room);

  @override
  List<Object?> get props => [];
}

class ChatRoomsLoaded extends WebSocketState {
  final List<ChatRoomEntity> rooms;
  final int currentPage;
  final bool hasMore;

  ChatRoomsLoaded(this.rooms, this.currentPage, this.hasMore);

  @override
  List<Object?> get props => [rooms];
}

class ChatRoomsLoadingMore extends ChatRoomsLoaded {
  ChatRoomsLoadingMore(super.rooms, super.currentPage, super.hasMore);
}

class ChatRoomsError extends WebSocketState {
  final String error;

  ChatRoomsError(this.error);

  @override
  List<Object?> get props => [error];
}

class WebSocketInitial extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class WebSocketConnecting extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class WebSocketConnected extends WebSocketState {
  @override
  List<Object?> get props => [];
}

class WebSocketDisconnected extends WebSocketState {
  @override
  List<Object?> get props => [];
}

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
