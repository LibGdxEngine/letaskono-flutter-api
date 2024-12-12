import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class LoadMessages {
  final ChatRepository repository;

  LoadMessages(this.repository);

  Future<List<ChatMessageEntity>> call(int roomId) async {
    return await repository.loadMessages(roomId);
  }
}