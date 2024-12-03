import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class RemoveFromFavourites {
  final UserRepository repository;

  RemoveFromFavourites(this.repository);

  Future<String> call(String userCode) async {
    return await repository.removeFromFavourites(userCode);
  }
}
