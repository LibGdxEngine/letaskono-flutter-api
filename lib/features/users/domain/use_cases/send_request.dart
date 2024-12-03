import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class SendRequest {
  final UserRepository repository;

  SendRequest(this.repository);

  Future<String> call(String receiverId) async {
    return await repository.sendRequest(receiverId);
  }
}
