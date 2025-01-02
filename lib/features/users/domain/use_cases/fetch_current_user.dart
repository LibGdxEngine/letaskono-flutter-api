// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class FetchCurrentUser {
  final UserRepository repository;

  FetchCurrentUser(this.repository);

  Future<UserDetailsEntity> call() async {
    return await repository.fetchCurrentUser();
  }
}
