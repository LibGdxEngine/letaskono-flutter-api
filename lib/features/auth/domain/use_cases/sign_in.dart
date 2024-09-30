// lib/features/auth/domain/use_cases/sign_up.dart
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<String> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}
