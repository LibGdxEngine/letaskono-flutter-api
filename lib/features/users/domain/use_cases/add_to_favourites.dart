import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class AddToFavourites {
  final UserRepository repository;

  AddToFavourites(this.repository);

  Future<String> call(String userCode) async {
    return await repository.addToFavourites(userCode);
  }
}
