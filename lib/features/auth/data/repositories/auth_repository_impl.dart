// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:letaskono_flutter/features/auth/domain/entities/ProfileSetupEntity.dart';

import '../../domain/entities/AuthEntity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> signUp(
      String firstName, String lastName, String email, String password) async {
    return await remoteDataSource.signUp(firstName, lastName, email, password);
  }

  @override
  Future<void> confirmAccount(String code) async {
    return await remoteDataSource.confirmAccount(code);
  }

  @override
  Future<void> completeProfile(ProfileCompletion profileCompletion) async {
    return await remoteDataSource.completeProfile(profileCompletion.toJson());
  }

  @override
  Future<AuthEntity> getUserData() async {
    return await remoteDataSource.getUserData();
  }

  @override
  Future<bool> isUserActivated(String userId) async {
    // Implement the logic for checking if the user is activated
    return true; // Replace with actual logic
  }

  @override
  Future<String> signIn(String email, String password) async {
    return await remoteDataSource.signIn(email, password);
  }

  @override
  Future<void> passwordReset(String email) async {
    return await remoteDataSource.passwordReset(email);
  }

  @override
  Future<void> passwordVerify(String code, String newPassword) async {
    return await remoteDataSource.passwordVerify(code, newPassword);
  }

  @override
  Future<String> resendActivationCode(String email) async {
    return await remoteDataSource.resendActivationCode(email);
  }

}
