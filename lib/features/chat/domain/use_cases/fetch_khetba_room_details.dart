import 'package:letaskono_flutter/features/chat/data/models/chat_room.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class FetchKhetbaRoomDetails {
  final ChatRepository repository;

  FetchKhetbaRoomDetails(this.repository);

  Future<ChatRoom> call(int roomId) {
    return repository.getKhetbaDetails(roomId);
  }
}
