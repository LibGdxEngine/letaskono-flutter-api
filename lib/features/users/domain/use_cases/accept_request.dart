import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class AcceptRequest {
  final UserRepository repository;

  AcceptRequest(this.repository);

  Future<String> call(int requestId) async {
    return await repository.acceptRequest(requestId);
  }
}
