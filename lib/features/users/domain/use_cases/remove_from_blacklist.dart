import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class RemoveFromBlacklist {
  final UserRepository repository;

  RemoveFromBlacklist(this.repository);

  Future<String> call(String userCode) async {
    return await repository.removeFromBlacklist(userCode);
  }
}
