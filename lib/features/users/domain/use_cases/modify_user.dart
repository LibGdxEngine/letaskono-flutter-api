// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserModifyEntity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class ModifyUser {
  final UserRepository repository;

  ModifyUser(this.repository);

  Future<UserDetailsEntity> call(ProfileChangeEntity pce) async {
    return await repository.modifyUser(pce);
  }
}
