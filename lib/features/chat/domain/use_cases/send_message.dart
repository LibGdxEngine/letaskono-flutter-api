import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  void call(ChatMessageEntity message, int roomId) {
    return repository.sendMessage(message, roomId);
  }
}
