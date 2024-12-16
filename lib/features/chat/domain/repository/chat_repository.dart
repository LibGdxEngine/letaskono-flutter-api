import '../enitity/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> loadMessages(int roomId);

  Stream<dynamic> connectToChat(String roomId);

  void dispose();

  void sendMessage(ChatMessageEntity message,int roomId);
}
