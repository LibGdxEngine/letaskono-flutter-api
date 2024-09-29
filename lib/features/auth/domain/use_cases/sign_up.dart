// lib/features/auth/domain/use_cases/sign_up.dart
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<void> call(String firstName, String lastName, String email, String password) async {
    return await repository.signUp(firstName, lastName, email, password);
  }
}
