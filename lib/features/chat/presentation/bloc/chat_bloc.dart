import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/disconnect_from_chat.dart';
import 'package:letaskono_flutter/features/chat/domain/use_cases/load_messages.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:equatable/equatable.dart';
import 'package:letaskono_flutter/core/di/injection_container.dart';

import '../../domain/use_cases/connect_to_chat.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketChannel? _channel;
  final LoadMessages loadMessagesUseCase = sl<LoadMessages>();
  final ConnectToChat connectToChatUseCase = sl<ConnectToChat>();
  final DisconnectFromChat disconnectFromChatUseCase = sl<DisconnectFromChat>();

  WebSocketBloc() : super(WebSocketInitial()) {
    on<ConnectWebSocket>(_onConnect);
    on<DisconnectWebSocket>(_onDisconnect);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onConnect(event, emit) async {
    emit(WebSocketConnecting());
    try {
      final List<ChatMessageEntity> loadedMessages =
          await loadMessagesUseCase(event.roomId);
      for (final message in loadedMessages) {
        emit(WebSocketMessageReceived(message));
      }
      final channel = connectToChatUseCase(event.roomId.toString());
      emit(WebSocketConnected());
      // Listen for incoming messages
      channel.listen(
        (message) {
          final messageAsJson = jsonDecode(message);
          add(ReceiveMessage(ChatMessageEntity.fromJson(messageAsJson)));
        },
        onDone: () => add(DisconnectWebSocket()),
        onError: (error) => add(DisconnectWebSocket()),
      );
    } catch (e) {
      emit(WebSocketError(e.toString()));
    }
  }

  Future<void> _onReceiveMessage(event, emit) async {
    emit(WebSocketMessageReceived(event.message));
  }

  Future<void> _onDisconnect(event, emit) async {
    await _channel?.sink.close();
    emit(WebSocketDisconnected());
  }

  Future<void> _onSendMessage(event, emit) async {
    if (_channel != null) {
      _channel?.sink.add(jsonEncode({'message': event.content}));
    }
  }

  @override
  Future<void> close() {
    disconnectFromChatUseCase();
    return super.close();
  }
}
