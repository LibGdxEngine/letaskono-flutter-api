import 'package:letaskono_flutter/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:letaskono_flutter/features/chat/data/models/chat_message.dart';
import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/enitity/chat_room_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

import '../models/chat_room.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  // Constructor with initializer list
  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatMessageEntity>> loadMessages(int roomId) async {
    final List<ChatMessage> messages =
        await remoteDataSource.loadMessages(roomId);
    return messages.map((message) => _mapMessageToEntity(message)).toList();
  }

  ChatMessageEntity _mapMessageToEntity(ChatMessage message) {
    return ChatMessageEntity(
      content: message.content,
      senderId: message.senderId,
      type: message.type,
      timestamp: message.timestamp,
      isRead: message.isRead,
      id: message.id,
    );
  }

  @override
  Stream<dynamic> connectToChat(String roomId) {
    return remoteDataSource.connectToChat(roomId);
  }

  @override
  void dispose() {
    return remoteDataSource.dispose();
  }

  @override
  void sendMessage(ChatMessageEntity message, int roomId) {
    remoteDataSource.sendMessage(message, roomId);
  }

  @override
  Future<List<ChatRoomEntity>> fetchChatRooms({required int page}) async {
    final List<ChatRoom> rooms = await remoteDataSource.fetchChatRooms(page);
    return rooms.map((room) => _mapChatRoomToEntity(room)).toList();
  }

  @override
  Future<Map<String, dynamic>> updateState(String state, int roomId) async {
    return await remoteDataSource.updateState(state, roomId);
  }

  ChatRoomEntity _mapChatRoomToEntity(ChatRoom room) {
    return ChatRoomEntity(
      id: room.id,
      name: room.name,
      state: room.state,
      male: room.male,
      female: room.female,
      currentUserCode: room.currentUserCode,
      createdAt: room.createdAt,
      maleMessageCount: room.maleMessageCount,
      femaleMessageCount: room.femaleMessageCount,
      maleState: room.maleState,
      femaleState: room.femaleState,
    );
  }

  @override
  Future<ChatRoom> getKhetbaDetails(int roomId)async {
    return await remoteDataSource.getKhetbaDetails(roomId);
  }
}
