import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class DisconnectFromChat {
  final ChatRepository repository;

  DisconnectFromChat(this.repository);

  void call() {
    return repository.dispose();
  }
}
