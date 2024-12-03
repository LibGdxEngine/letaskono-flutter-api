// lib/features/auth/domain/use_cases/password_reset.dart
import '../repositories/auth_repository.dart';

class PasswordVerify {
  final AuthRepository repository;

  PasswordVerify(this.repository);

  Future<void> call(String code, String newPassword) async {
    return await repository.passwordVerify(code, newPassword);
  }
}
