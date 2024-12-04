// lib/features/auth/domain/use_cases/sign_up.dart
import 'package:letaskono_flutter/features/requests/domain/entities/AcceptanceRequestEntity.dart';

import '../repositories/request_repository.dart';

class FetchRequests {
  final RequestRepository repository;

  FetchRequests(this.repository);

  Future<List<AcceptanceRequestEntity>> call() async {
    return await repository.fetchRequests();
  }
}
