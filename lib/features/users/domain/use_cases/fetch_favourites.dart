// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class FetchFavourites {
  final UserRepository repository;

  FetchFavourites(this.repository);

  Future<List<UserEntity>> call({required int page}) async {
    return await repository.fetchFavourites(page: page);
  }
}
