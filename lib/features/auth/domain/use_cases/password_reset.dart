// lib/features/auth/domain/use_cases/password_reset.dart
import '../repositories/auth_repository.dart';

class PasswordReset {
  final AuthRepository repository;

  PasswordReset(this.repository);

  Future<void> call(String email) async {
    return await repository.passwordReset(email);
  }
}
