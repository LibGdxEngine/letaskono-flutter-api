import 'package:letaskono_flutter/features/chat/domain/enitity/chat_message_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class ConnectToChat {
  final ChatRepository repository;

  ConnectToChat(this.repository);

  Stream<dynamic> call(String roomId) {
    return repository.connectToChat(roomId);
  }
}
