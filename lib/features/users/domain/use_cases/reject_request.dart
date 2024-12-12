import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class RejectRequest {
  final UserRepository repository;

  RejectRequest(this.repository);

  Future<String> call(int requestId) async {
    return await repository.rejectRequest(requestId);
  }
}
