import 'package:letaskono_flutter/features/chat/domain/enitity/chat_room_entity.dart';

import '../../data/models/chat_room.dart';
import '../enitity/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> loadMessages(int roomId);

  Stream<dynamic> connectToChat(String roomId);

  void dispose();

  void sendMessage(ChatMessageEntity message,int roomId);

  Future<Map<String, dynamic>> updateState(String state, int roomId);

  Future<List<ChatRoomEntity>> fetchChatRooms({required int page});

  Future<ChatRoom> getKhetbaDetails(int roomId);
}
