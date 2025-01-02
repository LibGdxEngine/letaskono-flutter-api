// lib/features/auth/domain/use_cases/resend_activation_code.dart
import 'package:letaskono_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserModifyEntity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class ResendActivationCode {
  final AuthRepository repository;

  ResendActivationCode(this.repository);

  Future<String> call(String email) async {
    return await repository.resendActivationCode(email);
  }
}
