// lib/features/auth/domain/use_cases/sign_up.dart

import 'package:letaskono_flutter/features/chat/domain/enitity/chat_room_entity.dart';
import 'package:letaskono_flutter/features/chat/domain/repository/chat_repository.dart';

class FetchChatRooms {
  final ChatRepository repository;

  FetchChatRooms(this.repository);

  Future<List<ChatRoomEntity>> call({required int page}) async {
    return await repository.fetchChatRooms(page: page);
  }
}
