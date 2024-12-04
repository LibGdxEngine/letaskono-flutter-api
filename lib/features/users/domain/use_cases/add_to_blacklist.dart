import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class AddToBlacklist {
  final UserRepository repository;

  AddToBlacklist(this.repository);

  Future<String> call(String userCode) async {
    return await repository.addToBlacklist(userCode);
  }
}
