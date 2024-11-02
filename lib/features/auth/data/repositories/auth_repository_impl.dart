// lib/features/auth/data/repositories/auth_repository_impl.dart
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
  Future<void> completeProfile(AuthEntity userProfile) async {
    return await remoteDataSource.completeProfile(UserModel(
      id: userProfile.id,
      firstName: userProfile.firstName,
      lastName: userProfile.lastName,
      email: userProfile.email,
    ));
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
}
