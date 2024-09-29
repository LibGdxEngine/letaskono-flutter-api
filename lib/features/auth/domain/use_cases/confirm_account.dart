// lib/features/auth/domain/use_cases/confirm_account.dart
import '../repositories/auth_repository.dart';

class ConfirmAccount {
  final AuthRepository repository;

  ConfirmAccount(this.repository);

  Future<void> call(String code) async {
    return await repository.confirmAccount(code);
  }
}
