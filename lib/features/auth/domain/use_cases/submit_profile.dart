// lib/features/auth/domain/use_cases/submit_profile.dart
import '../entities/AuthEntity.dart';
import '../repositories/auth_repository.dart';

class CompleteProfile {
  final AuthRepository repository;

  CompleteProfile(this.repository);

  Future<void> call(AuthEntity userProfile) async {
    return await repository.completeProfile(userProfile);
  }
}
