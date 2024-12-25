// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/users/domain/entities/search_entity.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';
import 'package:letaskono_flutter/features/users/domain/repositories/user_repository.dart';

class SetOnline {
  final UserRepository repository;

  SetOnline(this.repository);

  Future<String> call() async {
    return await repository.setOnline();
  }
}
