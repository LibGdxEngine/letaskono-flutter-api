// lib/features/auth/domain/use_cases/submit_profile.dart
import 'package:letaskono_flutter/features/auth/domain/entities/ProfileSetupEntity.dart';

import '../entities/AuthEntity.dart';
import '../repositories/auth_repository.dart';

class CompleteProfile {
  final AuthRepository repository;

  CompleteProfile(this.repository);

  Future<void> call(ProfileCompletion profileCompletion) async {
    return await repository.completeProfile(profileCompletion);
  }
}
