import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:letaskono_flutter/features/chat/data/models/chat_room.dart';
import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/disconnect_from_chat.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/fetch_khetba_room_details.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/load_messages.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/update_chat_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';

import '../../domain/enitity/chat_room_entity.dart';
import '../../domain/use_cases/connect_to_chat.dart';
import '../../domain/use_cases/fetch_chat_rooms.dart';
import '../../domain/use_cases/send_message.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketChannel? _channel;
  final LoadMessages loadMessagesUseCase = sl<LoadMessages>();
  final ConnectToChat connectToChatUseCase = sl<ConnectToChat>();
  final SendMessage sendMessageUseCase = sl<SendMessage>();
  final DisconnectFromChat disconnectFromChatUseCase = sl<DisconnectFromChat>();
  final FetchChatRooms fetchChatRoomsUseCase = sl<FetchChatRooms>();
  final UpdateChatState updateChatStateUseCase = sl<UpdateChatState>();
  final FetchKhetbaRoomDetails FetchKhetbaRoomDetailsUseCase =
      sl<FetchKhetbaRoomDetails>();

  WebSocketBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnect);
    on<DisconnectWebSocket>(_onDisconnect);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<ReachMessageLimit>(_onMessageLimitReached);
    on<FetchChatRoomsEvent>(_onFetchChatRooms);
    on<ChatStateUpdated>(_onChatStateUpdated);
    on<EnterKhetbaPage>(_onKhetbaDetailsRequested);
  }

  Future<void> _onConnect(event, emit) async {
    emit(WebSocketConnecting());
    try {
      final List<ChatMessageEntity> loadedMessages =
          await loadMessagesUseCase(event.roomId);
      for (final message in loadedMessages) {
        add(ReceiveMessage(message));
      }
      final channel = connectToChatUseCase(event.roomId.toString());
      emit(WebSocketConnected());
      // Listen for incoming messages
      channel.listen(
        (message) {
          final messageAsJson = jsonDecode(message);
          if (messageAsJson.containsKey('error')) {
            if (!isClosed) add(ReachMessageLimit(messageAsJson['error']));
          } else {
            if (!isClosed) {
              add(ReceiveMessage(ChatMessageEntity.fromJson(messageAsJson)));
            }
          }
        },
        onDone: () => print('Done'),
        onError: (error) => print('Error'),
      );
    } catch (e) {
      emit(WebSocketError(e.toString()));
    }
  }

  Future<void> _onReceiveMessage(event, emit) async {
    emit(WebSocketMessageReceived(event.message));
  }

  Future<void> _onDisconnect(event, emit) async {
    disconnectFromChatUseCase();
    emit(WebSocketDisconnected());
  }

  Future<void> _onSendMessage(event, emit) async {
    sendMessageUseCase(event.message, event.roomId);
  }

  Future<void> _onMessageLimitReached(event, emit) async {
    emit(MessageLimitReached(event.message));
  }

  Future<void> _onFetchChatRooms(event, emit) async {
    final currentState = state;

    if (currentState is ChatRoomsLoaded ||
        currentState is ChatRoomsLoadingMore) {
      if (!event.isRefreshing && !(currentState as ChatRoomsLoaded).hasMore)
        return; // Prevent fetch if no more data

      emit(ChatRoomsLoadingMore((currentState as ChatRoomsLoaded).rooms,
          currentState.currentPage, currentState.hasMore));

      try {
        final newChatRooms = await fetchChatRoomsUseCase(
            page: event.page); // Fetch notifications
        final hasMore = newChatRooms.isNotEmpty; // Check if more data exists

        emit(ChatRoomsLoaded(
            currentState.rooms + newChatRooms, event.page, hasMore));
      } catch (error) {
        emit(ChatRoomsError(error.toString()));
      }
    } else {
      // Initial load
      try {
        final rooms = await fetchChatRoomsUseCase(page: event.page);
        emit(ChatRoomsLoaded(rooms, event.page, rooms.isNotEmpty));
      } catch (error) {
        emit(ChatRoomsError(error.toString()));
      }
    }
  }

  FutureOr<void> _onChatStateUpdated(
      ChatStateUpdated event, Emitter<WebSocketState> emit) async {
    try {
      final response = await updateChatStateUseCase(event.state, event.roomId);

      emit(ChatRoomStateUpdated(response['room_id'].toString()!,
          response['male_state']!, response['female_state']!));
    }catch(error){
      emit(ChatRoomsError(error.toString()));
    }
  }

  FutureOr<void> _onKhetbaDetailsRequested(
      EnterKhetbaPage event, Emitter<WebSocketState> emit) async {
    final response = await FetchKhetbaRoomDetailsUseCase(event.roomId);
    emit(KhetbaStageEntered(response));
  }
}
