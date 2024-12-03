// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:letaskono_flutter/features/auth/domain/entities/ProfileSetupEntity.dart';

import '../entities/AuthEntity.dart';

abstract class AuthRepository {
  Future<void> signUp(String firstName, String lastName, String email, String password);
  Future<String> signIn(String email, String password);
  Future<void> passwordReset(String email);
  Future<void> passwordVerify(String code, String newPassword);
  Future<void> confirmAccount(String code);
  Future<void> completeProfile(ProfileCompletion profileCompletion);
  Future<AuthEntity> getUserData();
  Future<bool> isUserActivated(String userId);
}
