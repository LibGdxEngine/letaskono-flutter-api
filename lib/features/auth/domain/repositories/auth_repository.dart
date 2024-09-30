// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/AuthEntity.dart';

abstract class AuthRepository {
  Future<void> signUp(String firstName, String lastName, String email, String password);
  Future<String> signIn(String email, String password);
  Future<void> confirmAccount(String code);
  Future<void> submitProfile(AuthEntity userProfile);
  Future<AuthEntity> getUserData();
  Future<bool> isUserActivated(String userId);
}
