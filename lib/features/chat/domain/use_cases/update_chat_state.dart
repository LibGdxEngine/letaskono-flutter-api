import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class UpdateChatState {
  final ChatRepository repository;

  UpdateChatState(this.repository);

  Future<Map<String, dynamic>> call(String state, int roomId) {
    return repository.updateState(state, roomId);
  }
}
