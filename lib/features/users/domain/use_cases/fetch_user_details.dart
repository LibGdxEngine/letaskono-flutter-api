// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class FetchUserDetails {
  final UserRepository repository;

  FetchUserDetails(this.repository);

  Future<UserDetailsEntity> call(String userCode) async {
    return await repository.fetchUserDetails(userCode);
  }
}
